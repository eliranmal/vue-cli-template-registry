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

best for a one-time installation of an arbitrary custom template. no residue on the file-system, no strings attached!
make sure to replace `<awesome-cli-template>` with your custom template clone URL (or local path).

```sh
curl -sf https://raw.githubusercontent.com/eliranmal/vue-cli-template-registry/master/bin/registry.sh | bash -s install <awesome-cli-template>
```

building your own custom template? add this one-liner to the custom template readme page.


#### via NPM

this is the most convenient way to work with the registry if you have many custom templates you'd like to install, or otherwise need to tinker with the installation command options.

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

if you installed the registry locally, you will find its command available in the terminal.
regardless, the CLI options are the same.

the first argument can be either `install`, `uninstall` or `update`, and the second is used for passing in
the custom template source, either in the form of a github clone URL, or a local path pointing at your custom template. 

use the `-h` flag for more details.





[1]: https://img.shields.io/npm/v/vue-cli-template-registry.svg?style=flat-square
[2]: https://www.npmjs.com/package/vue-cli-template-registry
[3]: https://github.com/vuejs/vue-cli/tree/master#custom-templates
