# deno-wrap

Some bash and typescript scripts that "wrap" a deno installation and make it a little easier to use or manage. I'm experimenting.

`bin/deno-install-here.sh` is a bash script that will install [deno](https://deno.land/manual.html) using deno's install bash script [`install.sh`](https://github.com/denoland/deno_install/blob/master/install.sh). It also creates a simple versioning scheme that allows several deno images to be installed cotemperaneously. 

To use it, first "set it up":

``bash
git clone git@github.com:mcarifio/deno-wrap
sudo install --owner=${USER} --group=${USER} --directory /opt/deno
ln --verbose --force deno-wrap/bin/deno-install-here.sh /opt/deno # make a hard link
```

and then after that use it:

```bash
/opt/deno/deno-install-here.sh
/opt/deno/current/bin/deno --version
deno: 0.16.0
v8: 7.7.200
typescript: 3.5.1
```


