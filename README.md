# vue-cli-template-registry

*a solution for vue-cli custom templates on private repositories*

[![NPM][1]][2]

---

## overview

&hellip;


## setup

choose your preferred setup method.


#### none

best for a one-time installation of an arbitrary custom-template. no residue on the file-system, no strings attached!

```sh
curl -sf https://raw.githubusercontent.com/eliranmal/vue-cli-template-registry/master/bin/registry.sh | bash -s install <awesome-cli-template>
```


#### via NPM

this is the most convenient way to work with the registry if you have many custom-templates you'd like to install, or otherwise need to tinker with the installation command options.

```sh
npm i -g vue-cli-template-registry
```


#### manual

if you don't use NPM, you can just copy this script to your local `bin`.

```sh
curl -f -O https://raw.githubusercontent.com/eliranmal/vue-cli-template-registry/master/bin/registry.sh
install -v -m 0755 ./registry.sh /usr/local/bin/vue-cli-template-registry
rm -v ./registry.sh
```


## usage

from the terminal, run the registry script:

```sh
vue-cli-template-registry
```

&hellip;

```sh
vue-cli-template-registry 'arg' 'option'
```

&hellip;

&hellip; the `WAT` environment variable:

```sh
env WAT='serve' vue-cli-template-registry
```


## CLI

use the `-h` flag to see the manual.





[1]: https://img.shields.io/npm/v/vue-cli-template-registry.svg?style=flat-square
[2]: https://www.npmjs.com/package/vue-cli-template-registry
[3]: https://github.com/vuejs/vue-cli/tree/master#custom-templates
