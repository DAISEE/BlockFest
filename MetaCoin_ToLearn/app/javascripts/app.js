var accounts;
var account;
var balance;

function setStatus(message) {
  var status = document.getElementById("status");
  status.innerHTML = message;
  
};

function refreshBalance() {
  var meta = MetaCoin.deployed();

  meta.getBalance.call(account, {from: account}).then(function(value) {
    var balance_element = document.getElementById("balance");
    balance_element.innerHTML = value.valueOf();
    refreshABalance();
  }).catch(function(e) {
    console.log(e);
    setStatus("Error getting balance; see log.");
  });
  
};

function sendCoin() {
  var meta = MetaCoin.deployed();

  var amount = parseInt(document.getElementById("amount").value);
  var receiver = document.getElementById("receiver").value;

  setStatus("Initiating transaction... (please wait)");

  meta.sendCoin(receiver, amount, {from: account}).then(function() {
    setStatus("Transaction complete!");
    refreshBalance();
  }).catch(function(e) {
    console.log(e);
    setStatus("Error sending coin; see log.");
  });
  
};

window.onload = function() {
  web3.eth.getAccounts(function(err, accs) {
    if (err != null) {
      alert("There was an error fetching your accounts.");
      return;
    }

    if (accs.length == 0) {
      alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
      return;
    }

    accounts = accs;
    account = accounts[0];   

    refreshBalance(); 
    
  });
}

function refreshABalance() {
  var meta = MetaCoin.deployed();
  $("#sandbox").html("");
  
  var promises = [];
  for(var i = 0; i<10; i++) {
	  promises.push(meta.getBalance.call(accounts[i], {from: accounts[i]}));
  }
    
  Promise.all(promises).then(function(values) {
	// all calls succeeded
	
	balances=values.map(e => e.toString());
	
	for(var i = 0; i<10; i++) {
		$("#sandbox").append("<div class='left_col'>"+accounts[i]+"</div><div class='right_col'>"+balances[i]+"</div><br />");
	}

  });
};
