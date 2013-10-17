# -*- coding: utf-8 -*-
pid    '/tmp/open-uploader.pid'
listen '/tmp/open-uploader.sock'
worker_processes 1
timeout 20

stdout_path "log/open-uploader-access.log"
stderr_path "log/open-uploader-error.log"
