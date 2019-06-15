
# vue-cli-template-registry

*a solution for vue-cli custom templates hosted on private/enterprise repositories*

[![NPM][1]][2]


## overview

this is a command-line tool that enables the usage of [vue-cli custom templates][3] hosted on private/enterprise repositories <sup>\[[1][100]]</sup>.

it stores the templates locally, so we can install them from a local path. for example:

```sh
vue init ~/.vue-cli-templates/my-awesome-template my-app
```


## setup

choose your preferred method:


#### none!

for a one-time installation of an arbitrary custom template, no setup is required.
skip ahead to the [usage][100] section for more details.


#### via NPM

this is the most convenient choice when you're dealing with multiple custom templates.

```sh
npm i -g vue-cli-template-registry
```


#### manual

if you don't use NPM, or you're just into typing stuff, you can manually copy the registry script to your local `bin` directory:

```sh
curl -f -O https://raw.githubusercontent.com/eliranmal/vue-cli-template-registry/master/bin/registry.sh
install -v -m 0755 ./registry.sh /usr/local/bin/vue-cli-template-registry
rm -v ./registry.sh
```


## usage

if you chose to skip the setup, you can use a single command line to fetch and run the registry <sup>\[[2][101]]</sup>:

```sh
curl -sf https://raw.githubusercontent.com/eliranmal/vue-cli-template-registry/master/bin/registry.sh | bash -s install <awesome-cli-template>
```
  
:ok_hand: ***tip:** building your own custom template? add this one-liner to the readme page.*

if you followed the setup, you will find the `vue-cli-template-registry` command available in the terminal.  
it can be run with the same arguments <sup>\[[2][101]]</sup>:

```sh
vue-cli-template-registry install <awesome-cli-template>
```

the first argument is the registry command, and can be either `install`, `uninstall` or `update`.  
the second is for passing the custom template source, either in the form of a github clone URL, or a local path.

for more details use the `-h` flag.


## notes

1. *at the time of writing, vue-cli 2.x does not play nice with such repositories (see [this issue on the vue-cli repository][4]). if/when this issue is resolved, vue-cli-template-registry will become obsolete.*
2. *make sure to replace `<awesome-cli-template>` with your custom template clone URL (or local path).*



[1]: https://img.shields.io/npm/v/vue-cli-template-registry.svg?style=flat-square
[2]: https://www.npmjs.com/package/vue-cli-template-registry
[3]: https://github.com/vuejs/vue-cli/tree/master#custom-templates
[4]: https://github.com/vuejs/vue-cli/issues/3384

[100]: #usage
[101]: #notes
