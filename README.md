# puphpetbox

A PuPHPet/Puppet/Vagrant config that installs a local, virtual PHP development server/environment.

## Based on/uses

* [PuPHPet](http://puphpet.com)
* [Vagrant](http://vagrantup.com)
* [Puppet](http://puppetlabs.com)
* [Virtualbox](http://puppetlabs.com)
* [Ubuntu linux](http://www.ubuntu.com/)

## Benefits

This package installs a Linux-based local Virtual Machine (VM) which gives you [many advantages](https://jtreminio.com/2013/06/make_vagrant_up_yours/) over traditional LAMP stacks, such as WAMP/XAMPP/MAMP etc

Using vagrant will help you avoid and solve many environment-based problems, such as:

* filename case-sensitivity issues between Windows/Linux environments
* *"but it worked on my local machine!"* (yeah, that old chestnut)

It also makes it much easier to:

* create a server from scratch, and start again if you mess it up
* [push](http://www.vagrantup.com/blog/vagrant-push-to-deploy.html)/deploy your websites to a remote machine (I may cover this later)
* [share](http://docs.vagrantup.com/v2/share/) your development environment with anyone over the web 
* automate system and project setups, for example, setting file permissions programatically

## Usage

### First steps

**Windows users**, install [GIT for Windows](http://git-scm.com/download/win)

Install the latest versions of [Vagrant](http://vagrantup.com) and [Virtualbox](https://www.virtualbox.org/)

Clone this repo (right click in the dir and choose Git Bash) and use:

`git clone {repo_URL} {dir_to_clone_repo_into}`

You can then copy the `puphpet/` folder and `VagrantFile` to your project.

### Modify the default project settings to match your project

In `config.yaml`, modify the `synced_folder:` and `vhosts:` entries to match your project.

You only need to change the `target` unless you're using more than one vhost (I personally recommend that you have one VM per project), in which case you'll also need to change the `source`.

### vagrant up

---

**This is a good time to make sure any other local apache/nginx processes have been stopped, as they may interfere with your new VM.**

---

Go to your project folder and type `vagrant up`. This will create a new VM and sync your project folder to it, amongst other things.

Go and get a :coffee: while PuPHPet does it's thing. If you're on my team, heck, why not get me one while you're up? :wink:

As long as you don't see a sea of red text, everything should be fine!

### Access your new guest VM using SSH

Using terminal, go to your project folder and type `vagrant ssh` to log in to your guest (virtual) machine.

**Windows users tip** - in file explorer, shift-right click on an empty space and choose "Open command window here" in your project folder.

You could also use an SSH client of your choice, for instance [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html), but you will need to use the key file found in `puphpet/files/dot/ssh` (only generated after initial `vagrant up`). There is no passphrase necessary, and you should use `vagrant` as the username, unless you have changed it in `config.yaml`

**Windows users will need to use** [PuTTYGEN](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) in order to convert the ID_RSA keyfile to OpenSSH format.

### Set your hosts file (on host machine)

Open your hosts file on your operating system, and add (for the default setup).

`192.192.168.56.101 myproject.local`

This is so that your browser knows where to look when you type your local project's URL into your browser.

#### Hosts file locations

---

Windows   - `notepad C:\Windows\System32\drivers\etc\hosts`

OSX/Linux - `sudo nano /etc/hosts`

---

### Provisioning (applying your config.yaml/.sh file changes)

If you need update your guest machine with your latest config/scripts, use `vagrant provision`. 

### Stopping the VM (halt)

If you want to stop the VM, type `vagrant halt` from your project directory.

### Removing the VM (destroy)

If something bad happens to your VM, type `vagrant halt ; vagrant destroy` from your project directory. This will stop the machine if it's running, and remove it so you can start afresh.
 
---

## config.yaml (the good stuff)

Using config.yaml, you can tweak things to just how you like 'em:

### Guest VM hostname
```yaml
hostname: 'myproject-vagrant'
```
### Guest VM IP address
```yaml
private_network: 192.168.56.101
```
Tweak away to get it set up exactly how you need it!

You can also create a config-custom.yaml file to override config.yaml (in the same directory) 

### Apache/Nginx

Apache is enabled by default, but you can also choose NGINX (just don't use both at the same time!). 

Specify your apache vhosts as thus, ensuring each vhost has a unique key, e.g. `ynjzn9ilvpkn`, otherwise bad things will happen:

```yaml
apache:
    install: '1'
    settings:
        user: www-data
        group: www-data
        default_vhost: true
        manage_user: false
        manage_group: false
        sendfile: 0
    modules:
        - rewrite
    vhosts:
        ynjzn9ilvpkn:
            servername: myproject.local
            serveraliases:
                - myproject.local
            docroot: /var/www/public
            port: '80'
            setenv:
                - 'APP_ENV dev'
            directories:
                442wwqtqyrwh:
                    provider: directory
                    path: /var/www
                    options:
                        - Indexes
                        - FollowSymlinks
                        - MultiViews
                    allow_override:
                        - All
                    require:
                        - all
                        - granted
                    custom_fragment: ''
            engine: php
            custom_fragment: ''
            ssl_cert: ''
            ssl_key: ''
            ssl_chain: ''
            ssl_certs_dir: ''
    mod_pagespeed: 0

```    

### Synced folders

Specify the folder you would like to sync with your new VM:

(as with vhosts, ensure each synced_folder has a unique key)

```yaml

synced_folder:
    lklMPe5JTdPi:
        owner: www-data
        group: www-data
        source: 'C:/myproject'
        target: /var/www
        sync_type: default
        rsync:
            args:
                - '--verbose'
                - '--archive'
                - '-z'
            exclude:
                - .vagrant/
            auto: 'false'      

```               

You can also specify files you don't want to sync, change the sync type, and other stuff.

### Modules

This config installs the following modules by default - but you can enable anything you like in `config.yaml`

#### Linux packages

```yaml

packages:
    - htop
    - vim
    - screen
    - bmon
    - p7zip-full

```        

#### PHP modules

```yaml

modules:
	php:
	    - cli
	    - intl
	    - mcrypt
	    - curl
	    - mysql
	    - xdebug

```

#### Shell script files (.sh)

View [the PuPHPet website](https://puphpet.com/#system), scroll to the bottom of the page to learn how the scripts in `puphpet/files` work.

I've included files that install [Nodejs w/NPM](https://nodejs.org/), [PHP GD graphics library](http://php.net/manual/en/book.image.php) and [Memcached](http://memcached.org/). If you don't want to use these, simply delete the files! 

Add as many scripts as you like! However, **if you use Windows**, ensure you save the files with Unix *LF* character line endings, rather than Windows based *CRLF* endings, or they will error when you provision the machine.

## Suggestions

Any suggestions/improvements via Push Requests welcome! 

## Addendum

You can create your own PuPHPet config at the [PuPHPet website](http://puphpet.com) (created by Juan Treminio)
