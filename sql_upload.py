from fileinput import filename
import os
from dotenv import load_dotenv
import requests
import base64
from datetime import datetime
load_dotenv()
token = os.getenv("GITHUB_TOKEN")

def fetch_github_metrics(repo_owner, repo_name, token=token):
    url = f"https://api.github.com/repos/{repo_owner}/{repo_name}"
    headers = {"Authorization": f"token {token}"}
    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
    except requests.exceptions.RequestException as e:
        print(f"Error fetching data from GitHub: {e}")
        return None
    data = response.json()

    return data

def upload_queries_to_github(filename):
    fetch = fetch_github_metrics("Human-Gechi", "DAILY_SQL_PROBLEMS")
    if fetch:
        print("Fetched GitHub repository data successfully.")
    else:
        print("Failed to fetch GitHub repository data.")

    #Upload .sql files in repo to Githubusing this API
    file_directory = os.listdir(filename)
    for file in file_directory:
            if file.endswith('.py'):
                file_path = os.path.join(filename, file)
                with open(file_path, "r") as f:
                    content = f.read()
                    date = datetime.now().strftime("%Y-%m-%d")
                    url = f"https://api.github.com/repos/Human-Gechi/DAILY_SQL_PROBLEMS/contents/{file}"
                    headers = {"Authorization": f"token {token}"}

                    content_encoded = base64.b64encode(content.encode("utf-8")).decode("utf-8")
                    data = {
                        "message": f"Adding {file} on {date}",
                        "content" : content_encoded,
                    }
                    try:
                        response = requests.put(url, headers=headers, json=data)
                        response.raise_for_status()
                        print(f"Successfully uploaded {file} to GitHub.")
                    except requests.exceptions.RequestException as e:
                        print(f"Error uploading {file} to Github: {e}")
if __name__== "__main__":
     upload_queries_to_github(r"C:\Users\HP\OneDrive\Desktop\API_SNAPSHOT")
