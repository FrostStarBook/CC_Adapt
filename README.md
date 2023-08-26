# CC_Adapt

check version
```
 scarb --version    
```
```
scarb 0.6.2 (c07fa6155 2023-08-15)
cairo: 2.1.1 (https://crates.io/crates/cairo-lang-compiler/2.1.1)`

```

run hello_world

```
cd /starknet/cc_map 

scarb build && scarb cairo-run
```

fmt code
```
scarb fmt
```

## deploy contract via starkli
```
cd starknet/cc_map

scarb build

starkli declare --watch ./target/dev/cc_map_MyToken.sierra.json --account "../to/account.json" --keystore "../to/key.json" 

starkli deploy --watch 0x03e7c07172261b65d263f995fd8926b6752018f10c9c5ed4a41b3afdf789c356 --account "../to/account.json" --keystore "../to/key.json" 
```