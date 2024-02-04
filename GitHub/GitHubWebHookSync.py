import requests
import os
import re
import subprocess

GITHUB_USERNAME = "almoggal4"
GITHUB_PROJECT_NAME = "DevOpsApp"

GITHUB_API_ACCESS_TOKEN_FILE = r"c:\Users\almog\Desktop\PrivateFiles\GitHubAPIAccessToken.txt"
NGROK_DEFAULT_WEB_PORT = "4040"

with open(GITHUB_API_ACCESS_TOKEN_FILE, 'r') as f:
    GITHUB_API_ACCESS_TOKEN = f.read()
    print(GITHUB_API_ACCESS_TOKEN)

# find/create port for the ngork's information url
ngork_conf_file = os.popen('ngrok config check').read().replace("Valid configuration file at ", "").replace("/", "\\").replace("\n", "")
ngork_port = ""
with open(ngork_conf_file, 'r') as f:
    ngork_conf_web_port = f.read()
    for line in ngork_conf_web_port.split("\n"):
        if re.search("web_addr:", line):
            ngork_conf_web_port_configured = True
            ngork_port = line.split(" ")[1]
if not ngork_port:
    with open(ngork_conf_file, 'a') as f:
        f.write("web_addr: " + NGROK_DEFAULT_WEB_PORT)
        ngork_port = NGROK_DEFAULT_WEB_PORT

print("ngrok default port: " + ngork_port)

# create ngork public url forward to http://localhost:8080
# run the forward ip (if it is not running)
try:
    subprocess.Popen("'ngrok http 8080' >nul 2>&1")
except:
    print("Ngrok forward is already running")

# get the public ip
r = requests.get('http://localhost:' + ngork_port + '/api/tunnels')
ngork_public_url = r.json()['tunnels'][0]['public_url']

github_webhook_url = ngork_public_url + "/github-webhook/"
print(f"the new url is: {github_webhook_url}")

# check if there is a webhook
api_url = "https://api.github.com/repos/" + GITHUB_USERNAME + "/" + GITHUB_PROJECT_NAME + "/hooks"
headers = {"Accept": "application/vnd.github+json", "Authorization": "Bearer " + GITHUB_API_ACCESS_TOKEN,
           "X-GitHub-Api-Version": "2022-11-28"}
response = requests.get(api_url, headers=headers)
json_response = response.json()
# there is a webhook already
if len(json_response) == 1:
    print("Github webhook already exists - updating url")
    webhook_id = json_response[0]['id']
    api_url = "https://api.github.com/repos/" + GITHUB_USERNAME + "/" + GITHUB_PROJECT_NAME + "/hooks/" + str(webhook_id)
    headers = {"Accept": "application/vnd.github+json", "Authorization": "Bearer " + GITHUB_API_ACCESS_TOKEN,
               "X-GitHub-Api-Version": "2022-11-28"}
    body = {'config': {'content_type': 'form', 'insecure_ssl': '0', 'url': github_webhook_url}}
    response = requests.patch(api_url, json=body, headers=headers)
    json_response = response.json()
    print(json_response)
# create new webhook
else:
    print("Github webhook not exists - creating new webhook")
    api_url = "https://api.github.com/repos/" + GITHUB_USERNAME + "/" + GITHUB_PROJECT_NAME + "/hooks"
    headers = {"Accept": "application/vnd.github+json", "Authorization": "Bearer " + GITHUB_API_ACCESS_TOKEN,
               "X-GitHub-Api-Version": "2022-11-28"}
    body = {"name": "web", "active": True, "events": ["push"], "config":
            {"url": github_webhook_url, "content_type": "json", "insecure_ssl": "0"}}
    response = requests.post(api_url, json=body, headers=headers)
    json_response = response.json()
    print(json_response)
