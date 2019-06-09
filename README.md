
# vue-cli-template-registry

*a solution for vue-cli custom templates hosted on private/enterprise repositories*

[![NPM][1]][2]


## overview

this is a command-line tool that provides an easy way to use [vue-cli custom templates][5] hosted on private/enterprise repositories; it saves them locally, so we can install from a local path:

```sh
vue init ~/.vue-cli-templates/my-awesome-template my-app
```


## setup

choose your preferred method:


#### none!

for a one-time installation of an arbitrary custom template, no setup is required.
skip ahead to the [usage][4] section for more details.


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

if you chose to skip the setup, you can use a single command line to fetch and run the registry:

```sh
curl -sf https://raw.githubusercontent.com/eliranmal/vue-cli-template-registry/master/bin/registry.sh | bash -s install <awesome-cli-template>
```

<sup>make sure to replace `<awesome-cli-template>` with your custom template clone URL (or local path).</sup>

:ok_hand: ***tip:** building your own custom template? add this one-liner to the readme page.*
 

if you did follow the setup, you will find the `vue-cli-template-registry` command available in the terminal.
in any case, the command-line interface arguments and flags are the same.

the first argument can be either `install`, `uninstall` or `update`, and the second is used for passing in
the custom template source, either in the form of a github clone URL, or a local path pointing at your custom template project.

for more details use the `-h` flag.





[1]: https://img.shields.io/npm/v/vue-cli-template-registry.svg?style=flat-square
[2]: https://www.npmjs.com/package/vue-cli-template-registry
[3]: https://github.com/vuejs/vue-cli/tree/master#custom-templates
[4]: #usage
[5]: https://github.com/vuejs/vue-cli/tree/master#custom-templates
