import os, time
from datetime import datetime
from subprocess import run, PIPE, STDOUT

# Celery configuration
from celery import Celery
os.environ.setdefault('C_FORCE_ROOT', 'true')
app = Celery("tasks",
             broker=os.environ.get('CELERY_BROKER_URL', 'redis://redis'),
             backend=os.environ.get('CELERY_RESULT_BACKEND', 'redis://redis'))
app.conf.CELERY_WORKER_SEND_TASK_EVENTS = True

def execR(cmd):
    # Runs command and returns output (unless an error is raised)
    return run(cmd, check=True, stdout=PIPE, stderr=STDOUT, text=True).stdout

# Regarding running R expressions:
#   - Use 'cat(2+2)' to capture R output as a Celery result
#   - If the command raises an error, the task's state will be FAILURE

@app.task
def R(cmd):
    # Run R expression
    return execR(["Rscript", "-e", cmd])

@app.task
def Rscript(cmd):
    # Run Rscript
    return execR(["Rscript", cmd])

if __name__ == "__main__":
    app.start()
