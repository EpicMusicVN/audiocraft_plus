import io
from google.oauth2 import service_account, credentials
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload, MediaIoBaseDownload
from google.auth.transport import Request
from googleapiclient.errors import HttpError

def get_google_service():
    service_account_path = './client_secret.json'
    scopes = ['https://www.googleapis.com/auth/drive']
    credentials = service_account.Credentials.from_service_account_file(
        service_account_path, scopes=scopes
    )
    service = build('drive', 'v3', credentials=credentials)

    return service

def download_file(file_url, destination_path):
    try:
        service = get_google_service()
        file_id = file_url.split('/')[-2]

        request = service.files().get_media(fileId=file_id)
        # file = io.BytesIO()
        file = open(destination_path, 'wb')
        downloader = MediaIoBaseDownload(file, request)
        done = False
        while done is False:
            status, done = downloader.next_chunk()
            print(F'Download {int(status.progress() * 100)}.')

    except HttpError as error:
        print(F'An error occurred: {error}')
        file = None