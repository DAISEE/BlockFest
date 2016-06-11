Useful commands used thanks to Thibault

To debug, open Chrome/console
> var coin = MetaCoin.deployed()
> coin.getBalanceInEth.call("0xef096de5679cef5c23925122c12160d58a4f171b", {from: "0x3fdc2da7278187156f423ac42e41fab2d14137c0"}).then(v => console.log(v.toString()))


