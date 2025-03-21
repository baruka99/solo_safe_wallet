// UTXO Model (Unspent Transaction Output)

class Utxo {
  final String txId; //transaction ID
  final int outputIndex; // output index transaction
  final String address; // receiver addresse
  final double amount; //  avaible amount
  final int timestamp; // horodatage
  final String? scriptPubKey;
  final bool spent; // if spent

  Utxo({
    required this.txId,
    required this.outputIndex,
    required this.address,
    required this.amount,
    required this.timestamp,
    this.scriptPubKey,
    this.spent = false,
  });

  Map<String, dynamic> toMap() => {
        'txId': txId,
        'outputIndex': outputIndex,
        'address': address,
        'amount': amount,
        'timestamp': timestamp,
        'scriptPubKey': scriptPubKey,
        'spent': spent ? 1 : 0,
      };

  factory Utxo.fromMap(Map<String, dynamic> map) => Utxo(
        txId: map['txId'],
        outputIndex: map['outputIndex'],
        address: map['address'],
        amount: map['amount'],
        timestamp: map['timestamp'],
        scriptPubKey: map['scriptPubKey'],
        spent: map['spent'] == 1,
      );
}
