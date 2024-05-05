# How to run code from an env variable at Fly.io

## Problem

I'm making a side project that needed to ship custom code under machines with the same Dockerfile.

## My solution

I choose to do this through environment variables!

> This example will be in elixir but would work with pretty much any programming language!

tl;dr: we make a `run.sh` that `elixir TMP_file`

### 1. The entrypoint

Create a `run.sh` file like this:

```
#!/bin/sh
TMPFILE=$(mktemp)
echo "$CODE" > $TMPFILE
elixir $TMPFILE
```

Then make sure to make it executable with `chmod +x run.sh`.

### 2. The Dockerfile

Your Dockerfile should install your programming language and at the end `ADD run.sh /path/to/somewhere` and end with `CMD /path/to/somewhere/run.sh`. Here's an actual example: https://github.com/lubien/flyio-run-code-from-env-variable/blob/2c2b4c7b7ac7aab8b0bff95f405f3161660c05a5/Dockerfile#L21-L27

### 3. Preparing a fly.io app

Create your app using `fly launch --no-deploy`, tweak the `internal_port` to 4000 or whatever you want for your app. My example uses 4000.

Assuming your file is named `bug.ex` you can set the env variable as `CODE=`cat bug.exs` fly secrets set CODE="$CODE" --stage`. This will not trigger a deploy yet.

### 4. Deploy!

Run `fly deploy --ha=false` (disabling HA to make only one machine).

Your CLI will say that the deployment didn't work if it takes forever to compile (like my Elixir example) so don't worry. Use `fly logs` to see when it finishes compiling and starts the server.

Go to `your-app-name.fly.dev`

## Tips

If the above guide is confusing, it's fine look at the posts that I've wrote here: https://community.fly.io/t/how-to-run-code-from-an-env-variable/19669/2?u=lubien. 

I added detailed notes about me experimenting how to do this so there's more tips!
