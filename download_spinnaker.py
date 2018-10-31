#!/usr/bin/env python3

import requests
from tqdm import tqdm
from bs4 import BeautifulSoup
import time
import re
import os
import sys
import tarfile


class Session:
    HEADERS = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) '
               'AppleWebKit/537.36 (KHTML, like Gecko) '
               'Chrome/66.0.3359.181 Safari/537.36'}
    URL_BASE = 'https://www.ptgrey.com/'
    URL_LOGIN = URL_BASE + 'login?returnUrl=%2F'
    URL_DOWNLOAD = URL_BASE + "support/downloads/11048/"
    email = ''
    password = ''
    session = requests.session()
    filename = ''
    filesize = -1

    def __init__(self, email, password):
        self.email = email
        self.password = password

    def login(self):
        res = self.session.get(self.URL_LOGIN, headers=self.HEADERS)
        res.raise_for_status()
        soup = BeautifulSoup(res.content, "html.parser")
        payload = {
            "Email": self.email,
            "Password": self.password,
        }
        res = self.session.post(
                  self.URL_LOGIN, data=payload, headers=self.HEADERS)
        res.raise_for_status()
        soup = BeautifulSoup(res.content, "html.parser")

    def download(self):
        res = self.session.head(self.URL_DOWNLOAD, headers=self.HEADERS)
        res.raise_for_status()
        self.filesize = int(res.headers["Content-Length"])
        self.filename = re.findall(
                "filename=(.+\.tar\.gz)",
                res.headers['Content-Disposition']
                )[0]
        print("header parsing end. filename={}. filesize={}".format(self.filename, self.filesize))
        print("download start.")
        url_download = self.URL_DOWNLOAD
        res = self.session.get(url_download, headers=self.HEADERS, stream=True)
        res.raise_for_status()
        self.filename = re.findall(
                "filename=(.+\.tar\.gz)",
                res.headers['Content-Disposition']
                )[0]
        if not os.path.exists('./' + self.filename) and \
                not not self.filename:
            with open(self.filename, 'wb') as f:
                pbar = tqdm(total=self.filesize, unit="B", unit_scale=True)
                for chunk in res.iter_content(chunk_size=1024):
                    f.write(chunk)
                    pbar.update(len(chunk))
                pbar.close()
            print('file {} downloaded'.format(self.filename))

session = Session('code@clearpathrobotics.com', 'uNjRxoH6NMsJvi6hyPCH')

session.login()
session.download()
