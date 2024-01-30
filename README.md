# Shell Script Archive
This is an archive of Bash scripts for personal use. A fair deal of configuration will need to be done on your part if you wish to use these scripts yourself.

## Download the Project
You can either download the scripts as a ZIP or clone the repository by running the following command in your machine's terminal:

```bash
foo@bar:~$ git clone https://github.com/cadedupont/shell-script-archive.git
```

### Add Scripts to PATH
If you want to be able to execute the scripts from any directory on your machine without specifying the exact filepath, you'll need to add the directory to your machine's PATH variable.

This can be done in your `.bashrc` or `.zshrc` file (depending on which shell your system uses by default- on MacOS, it will likely be ZSH) with the following line:

```bash
export PATH=/path/to/scripts:$PATH
```

This will append the path to your scripts to the beginning of your PATH, meaning that your operating system will check that directory first when searching for the command you entered into the terminal. Likewise, if you want this directory to be checked last, you can adjust that line like so:

```bash
export PATH=$PATH:/path/to/scripts
```

### Make Scripts Executable

Ensure that these scripts are executable by running the following command in the directory containing the scripts:

```bash
foo@bar:/path/to/scripts$ chmod u+x clean.sh push.sh
```

## [`clean.sh`](clean.sh)
This is a script for removing all files in a directory that match a given pattern. This is useful for removing files that are generated by a compiler or interpreter, such as `.class` files in Java or `.pyc` files in Python.

The script takes a single argument: the directory to clean. If no argument is given, the script will default to the current directory. Below is an example of how to use the script:

```bash
foo@bar:~$ clean.sh /path/to/directory
```

Or, if you want the current directory to be cleaned:

```bash
foo@bar:~$ clean.sh
```

## [`push.sh`](push.sh)
This is a script for pushing a backup of my code to the University of Arkansas's Linux server for student use, Turing. As such, only those with access to that server will have the ability to use this script.

#### Generate RSA Key Pair
Because this script is intended to run automatically without user interaction, a way to log in to Turing without the use of password entry was needed. The solution to this was generating an RSA key pair, keeping the private key on the machine running the script and a copy of the public key in an `authorized_keys` file on Turing.

To generate a key pairing, execute the following commands while in the home directory in the terminal. Take note that a .ssh directory may already exist if you have logged on to Turing before, containing a `known_hosts` file:

```bash
foo@bar:~$ mkdir .ssh
foo@bar:~$ cd .ssh
foo@bar:~/.ssh$ ssh-keygen -t rsa
```

After completing these commands, you should now have 2 more files in the `.ssh` directory: `id_rsa` and `id_rsa.pub`. The file with the `.pub` extension is your public key- this is an important distinction as <b>you should never share the contents of your private key</b>.

You now need to send the public key to Turing. This can be done using the `scp` command:

```bash
foo@bar:~/.ssh$ scp id_rsa.pub your_username@turing.csce.uark.edu:~/
```

This sends a copy of the public key to your home directory on Turing. You now need to add the contents of this key to an `authorized_keys` file in a `~/.ssh` directory on Turing:

```bash
foo@bar:~$ ssh your_username@turing.csce.uark.edu
your_username@turing:~$ mkdir .ssh
your_username@turing:~$ mv id_rsa.pub .ssh
your_username@turing:~$ cd .ssh
your_username@turing:~/.ssh$ touch authorized_keys
your_username@turing:~/.ssh$ cat id_rsa.pub >> authorized_keys
your_username@turing:~/.ssh$ rm id_rsa.pub
```

This chain of commands will log you on to Turing, make a corresponding `.ssh` directory, move the copy of the public key to that directory, and append the key contents to a file used for authorized key pairings.

For security reasons, I recommend making your `.ssh` directory on Turing and your local machines only readable, writeable, and executable by the user by running `chmod` in your home directory:

```bash
your_username@turing:~/.ssh$ chmod 700 .
```

This should be sufficient if you replace all instances of `turing` in the `push` script with `your_username@turing.csce.uark.edu`. If you don't, you'll need to create a `config` file in the `.ssh` directory on your local machine and add the following:

```bash
Host turing
  HostName turing.csce.uark.edu
  IdentitiesOnly yes
  IdentityFile ~/.ssh/id_rsa
  User your_username
```

### Using `cron`
I have this script automated to run every day at 00:00 with `cron`. You can edit your current `cron` tasks by running the following command:

```bash
foo@bar:~$ crontab -e
```

A new file should open in the `vim` editor. Press `i` to enter insert mode and add the following:

```bash
PATH=/path/to/scripts:$PATH
0 0 * * * /path/to/push.sh
```

Press `esc` to exit insert mode and type `:wq` to save the file and exit `vim`. This script should now run every day at midnight.

If you wish to change how often the script runs, you can learn more about `cron`'s scheduling syntax [here](https://crontab.guru/).

## License

This project is licensed under the [MIT License](LICENSE).
