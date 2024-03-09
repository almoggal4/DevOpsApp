import requests
from lxml import etree
from bs4 import BeautifulSoup

# Jenkins API credentials and base URL
USERNAME = 'root'
PASSWORD = 'Lihialm1!'
JENKINS_URL = 'http://localhost:8080'
NEW_GITHUB_HOOK_URL = r'https://4de5-87-68-246-54.ngrok-free.app/github-webhook/'

SYSTEM_CONFIG_URL = f"{JENKINS_URL}/systemConfig.xml"
response = requests.get(SYSTEM_CONFIG_URL, auth=(USERNAME, PASSWORD))
xml_content = response.content.decode()
xml_content = xml_content.replace('<link ', '<link />')
xml_content = xml_content.replace('<meta ', '<meta />')
xml_content = xml_content.replace('<link ', '<link />')
xml_content = xml_content.replace('<script ', '<script />')
soup = BeautifulSoup(xml_content, 'xml')
github_hook_url = soup.find('githubWebHook')
if github_hook_url:
    github_hook_url['url'] = NEW_GITHUB_HOOK_URL
else:
    triggers_tag = soup.find('triggers')
    if not triggers_tag:
        triggers_tag = soup.new_tag('triggers')
        soup.append(triggers_tag)  # Append 'triggers' to the root element
    new_github_hook = soup.new_tag('githubWebHook', url=NEW_GITHUB_HOOK_URL)
    triggers_tag.append(new_github_hook)
modified_xml = str(soup)
print(modified_xml)
temp = requests.post(SYSTEM_CONFIG_URL, auth=(USERNAME, PASSWORD), data=modified_xml)
print(temp)
response = requests.get(SYSTEM_CONFIG_URL, auth=(USERNAME, PASSWORD))
print(response)
