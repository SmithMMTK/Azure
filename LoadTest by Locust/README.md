# Load Test by Locust
Website: [Locust](https://docs.locust.io/en/stable/quickstart.html)

## Installation
[Full detail instruction](https://docs.locust.io/en/stable/installation.html)

__Install Locustio__
```bash
    $ python -m pip install locustio
    
    Or
    
    $ python3 -m pip install -e git://github.com/locustio/locust.git@master#egg=locustio
 ```

    To see available options, run:

```bash
    $ locust --help
```

__Create locustfile.py__

```python
    from locust import HttpLocust, TaskSet
    
    def login(l):
        l.client.post("/login", {"username":"ellen_key", "password":"education"})

    def logout(l):
        l.client.post("/logout", {"username":"ellen_key", "password":"education"})

    def index(l):
        l.client.get("/")

    def profile(l):
        l.client.get("/profile")

    class UserBehavior(TaskSet):
        tasks = {index: 2, profile: 1}

        def on_start(self):
            login(self)

        def on_stop(self):
            logout(self)

    class WebsiteUser(HttpLocust):
        task_set = UserBehavior
        min_wait = 5000
        max_wait = 9000

```

```python
    from locust import HttpLocust, TaskSet, task

    class MyTaskSet(TaskSet):
        @task(2)
        def index(self):
            self.client.get("/")

        @task(1)
        def about(self):
            self.client.get("/about/")

    class MyLocust(HttpLocust):
        task_set = MyTaskSet
        min_wait = 5000
        max_wait = 15000
```

__Start Locust__

```bash
    $ locust --host=http://targetsite.com

    or

     $ locust -f locust_files/my_locust_file.py --host=http://example.com
```


__Open up Locust’s web interface__
Once you’ve started Locust using one of the above command lines, you should open up a browser and point it to http://127.0.0.1:8089 (if you are running Locust locally). Then you should be greeted with something like this:
