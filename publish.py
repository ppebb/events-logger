import os
import sys
import requests

MOD_PORTAL_URL = "https://mods.factorio.com"
INIT_UPLOAD_URL = f"{MOD_PORTAL_URL}/api/v2/mods/releases/init_upload"

apikey = os.environ["FACTORION_MOD_API_KEY"]
modname = os.environ["MOD_NAME"]
filepath = os.environ["RELEASE_ARTIFACT_PATH"]

request_body = data={"mod":modname}
request_headers = {"Authorization": f"Bearer {apikey}"}

response = requests.post(
    INIT_UPLOAD_URL,
    data=request_body,
    headers=request_headers)

if not response.ok:
    print(f"init_upload failed: {response.text}")
    sys.exit(1)

upload_url = response.json()["upload_url"]

with open(filepath, "rb") as f:
    request_body = {"file": f}
    response = requests.post(upload_url, files=request_body)

if not response.ok:
    print(f"upload failed: {response.text}")
    sys.exit(1)

print(f"upload successful: {response.text}")