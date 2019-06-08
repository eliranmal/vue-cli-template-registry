# vue-cli-template-registry

*a solution for vue-cli custom templates hosted on private/enterprise repositories*

[![NPM][1]][2]

---

## overview

a local registry for your vue-cli custom templates.  
to be used with private/enterprise hosted custom template repositories.


## setup

choose your preferred setup method:


#### none!

for a one-time installation of an arbitrary custom template, no setup is required.
skip ahead to the [usage][4] section for more details.


#### via NPM

this is the most convenient choice when you're dealing with multiple custom templates.

```sh
npm i -g vue-cli-template-registry
```


#### manual

if you don't use NPM, or you're just into typing stuff, you can manually copy the registry script to your local `bin` directory.

```sh
curl -f -O https://raw.githubusercontent.com/eliranmal/vue-cli-template-registry/master/bin/registry.sh
install -v -m 0755 ./registry.sh /usr/local/bin/vue-cli-template-registry
rm -v ./registry.sh
```


## usage

if you chose to skip the setup, you can alternatively fetch and run this script with a single command line. no residue on the file-system, no strings attached!

```sh
curl -sf https://raw.githubusercontent.com/eliranmal/vue-cli-template-registry/master/bin/registry.sh | bash -s install <awesome-cli-template>
```

make sure to replace `<awesome-cli-template>` with your custom template clone URL (or local path).

:ok_hand: ***tip:** building your own custom template? add this one-liner to the readme page.*
 

if you installed the registry locally, you will find the `vue-cli-template-registry` command available in the terminal.
in any case, the command-line interface arguments and flags are the same.

the first argument can be either `install`, `uninstall` or `update`, and the second is used for passing in
the custom template source, either in the form of a github clone URL, or a local path pointing at your custom template project.

use the `-h` flag for more details.





[1]: https://img.shields.io/npm/v/vue-cli-template-registry.svg?style=flat-square
[2]: https://www.npmjs.com/package/vue-cli-template-registry
[3]: https://github.com/vuejs/vue-cli/tree/master#custom-templates
[4]: #usage
