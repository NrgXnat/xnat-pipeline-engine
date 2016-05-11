#!/bin/env python
import os, sys, argparse, requests

versionNumber='1'
dateString='20150623'
author='flavin'
progName=os.path.basename(sys.argv[0])
idstring = '$Id: %s,v %s %s %s $'%(progName,versionNumber,dateString,author)

# Parse input args
parser = argparse.ArgumentParser(description='Upload directories of DICOM files. The name of each directory should be the scan number of the scan we will create.')
parser.add_argument('-v', '--version',
                    help='Print version number and exit',
                    action='version',
                    version=versionNumber)
parser.add_argument('--idstring',
                    help='Print id string and exit',
                    action='version',
                    version=idstring)
parser.add_argument('-s','--host',help='Server')
parser.add_argument('-u','--username',help='Username')
parser.add_argument('-p','--password',help='Password')
parser.add_argument('-i','--sessionId',help="Session's XNAT accession number")
# parser.add_argument('-l','--sessionLabel',help='Session label')
parser.add_argument('-w','--workflowId',help='Consolidate session history entries into one workflow entry with given ID')
parser.add_argument('-d','--delete',help='Should we delete existing remote scans before uploading? (Default: True. Use value False to fail upon finding a pre-existing scan.)')
parser.add_argument('-r','--regenerateMetadata',help='Should we pull scan metadata from the DICOM headers? (Default: True. Use value False to skip.)')
parser.add_argument('--debug',action='store_true' ,help='Should we pull scan metadata from the DICOM headers? (Default: True. Use value False to skip.)')
parser.add_argument('scanDirs',nargs='*',
                    help='Directories containing DICOM files you would like to upload. If none specified, use all subdirectories of pwd.')
args=parser.parse_args()

host = args.host
username = args.username
password = args.password
sessionId = args.sessionId
# sessionLabel = args.sessionLabel
delete = args.delete!="False"
regenerateMetadata = args.regenerateMetadata!="False"

def querify(queryDict):
    if len(queryDict)==0:
        return ""
    return "?" + "&".join( "=".join(kv) for kv in queryDict.iteritems() )

sess = requests.Session()
sess.verify = False
sess.auth = (username,password)

r = sess.get(host+'/data/experiments/{}?format=json'.format(sessionId))
r.raise_for_status()
sessionLabel = r.json()['items'][0]['data_fields']['label']

print "Preparing to upload local scans for session {}.".format(sessionLabel)

# Define list of scan directories
if len(args.scanDirs) > 0:
    print "I was given {} scan director{} to upload".format(len(args.scanDirs),"y" if len(args.scanDirs)==1 else "ies")
    print "Scan number, path"

    scans = [] # Will hold tuple (scanNumber,scanDir) for each scan
    for d in args.scanDirs:
        if not os.path.isdir(d):
            print "ERROR: {} is not a directory.".format(d)
            sys.exit("Exiting now.")
        if not os.access(d,os.R_OK):
            print "ERROR: I cannot read from {}.".format(d)
            sys.exit("Exiting now.")

        if d[-1]=='/':
            d = d.rstrip('/')

        scanTuple = (os.path.split(d)[1], os.path.abspath(d))
        print ", ".join(scanTuple)
        scans.append(scanTuple)
else:
    print "I was not given any directories to upload. Uploading from currect working directory instead."
    print "Scan number, path"

    scans = []
    for d in os.listdir(os.getcwd()):
        if not os.path.isdir(d):
            continue
        if not os.access(d,os.R_OK):
            print "ERROR: I found directory {} but cannot read from it.".format(d)
            sys.exit("Exiting now.")

        if d[-1]=='/':
            d = d.rstrip('/')

        scanTuple = (os.path.split(d)[1], os.path.abspath(d))
        print ", ".join(scanTuple)
        scans.append(scanTuple)


for (scanNum,scanDir) in scans:
    print "Beginning upload process for scan {}.".format(scanNum)

    # First, check if the scan exists
    print "Checking if scan {} exists remotely on the session.".format(scanNum)
    url = host+'/data/experiments/{}/scans/{}'.format(sessionId,scanNum)
    if args.debug: print "GET "+url
    r = sess.get(url)
    if args.debug: print r.status_code
    if r.ok:
        # We got an ok response, so the scan exists...
        print "Scan {} does exist on the session.".format(scanNum)
        if not delete:
            print "ERROR: I was instructed not to delete existing remote scans."
            sys.exit("Exiting now.")
        else:
            # Scan exists and we were told to delete it. Do so.
            print "Deleting remote scan {}.".format(scanNum)

            queryDict = {} if not args.workflowId else {"event_id":args.workflowId}
            queryDict["removeFiles"] = "true"
            url = host+'/data/experiments/{}/scans/{}{}'.format(sessionId,scanNum,querify(queryDict))
            if args.debug: print "DELETE "+url
            r = sess.delete(url)
            if args.debug: print "{} {}".format(r.status_code,r.text)
            r.raise_for_status()
    elif r.status_code==404:
        # Scan does not yet exist. This is ok no matter what.
        print "Scan {} does not yet exist on the session.".format(scanNum)
    else:
        print "ERROR: Received an error response {} from the server {}:".format(r.status_code,host)
        print r.text
        sys.exit("Exiting now.")

    # Create the scan
    print "Creating scan {}.".format(scanNum)
    queryDict = {} if not args.workflowId else {"event_id":args.workflowId}
    queryDict["xsiType"] = "xnat:mrScanData"
    url = host+'/data/experiments/{}/scans/{}{}'.format(sessionId,scanNum,querify(queryDict))
    if args.debug: print "PUT "+url
    r = sess.put(url)
    if args.debug: print "{} {}".format(r.status_code,r.text)
    r.raise_for_status()

    # Upload the files
    print "Uploading DICOM files."
    queryDict = {} if not args.workflowId else {"event_id":args.workflowId}
    queryDict["reference"] = scanDir
    queryDict["format"] = "DICOM"
    queryDict["overwrite"] = "true"
    url = host+'/data/experiments/{}/scans/{}/resources/DICOM/files{}'.format(sessionId,scanNum,querify(queryDict))
    if args.debug: print "PUT "+url
    r = sess.put(url)
    if args.debug: print "{} {}".format(r.status_code,r.text)
    r.raise_for_status()
    if r.status_code==417:
        print "ERROR: The request was not understood by the server. Files were not uploaded."
        print r.text
        sys.exit("Exiting now.")

    print ""

print "Done uploading."
print ""

if regenerateMetadata:
    print "Regenerating metadata for session {}.".format(sessionLabel)
    queryDict = {} if not args.workflowId else {"event_id":args.workflowId}
    queryDict['pullDataFromHeaders'] = 'true'
    url = host+'/data/experiments/{}{}'.format(sessionId,querify(queryDict))
    if args.debug: print "PUT "+url
    r = sess.put(url)
    if args.debug: print "{} {}".format(r.status_code,r.text)
    r.raise_for_status()
