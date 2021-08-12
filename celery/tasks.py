import os, subprocess, time
from datetime import datetime

# celery configuration
from celery import Celery
os.environ.setdefault('C_FORCE_ROOT', 'true')
app = Celery("tasks",
             broker=os.environ.get('CELERY_BROKER_URL', 'redis://redis'),
             backend=os.environ.get('CELERY_RESULT_BACKEND', 'redis://redis'))
app.conf.CELERY_WORKER_SEND_TASK_EVENTS = True

def createDir(dir):
    os.mkdir(dir)
    os.chdir(dir)

def rmEmptyDir(dir):
    if len( os.listdir(dir) ) == 0:
        os.rmdir(dir)

@app.task(bind=True)
def R(self, cmd):
    # Use task ID to create new folder to save task data
    taskID = self.request.id
    createDir(taskID)

    # Run R process
    cmd = "R -e '" + cmd + "'"
    subprocess.run(cmd, shell=True)

    # Go back from folder and remove task folder if empty
    os.chdir("..")
    rmEmptyDir(taskID)
    return "hello"

if __name__ == "__main__":
    app.start()
