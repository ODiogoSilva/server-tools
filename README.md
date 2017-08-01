# server-tools

A collection of compiled NGS tools for distribution across servers.

## Motivation

The aim of this repository is to provide a means of distributing compiled binaries and executables of NGS tools across multiple servers. Instead of maintaining each software separately on each machine, they are compiled and prepared on a single one, pushed, and are ready to be pulled and used in other servers with a similar architecture.

## Compiling machine

Ubuntu server 14.04 3.13.0-123-generic x86_64

gcc version 4.8.4 (Ubuntu 4.8.4-2ubuntu1~14.04.3)

glibc-2.19-1

## How to use

1. Clone the repository:

```
git clone https://github.com/ODiogoSilva/server-tools.git
```

2. Add the `server-tools/bin` directory the `$PATH` environmental variable

3. Programs are ready to use!

## How to update

1. Pull the repository

2. Programs are updated!


## Tools

- [HISAT2](https://ccb.jhu.edu/software/hisat2/index.shtml)

## Disclaimer

Feel free to use this repository on your own servers/machines, which is under the GPL3 licence. However, note that these binaries were meant to be used in the servers of the repository contributors, so there is no warranty for other machines. 
