import 'dart:async';
import 'package:flutter/material.dart';
import 'package:solosafe/services/shared_pref.dart';

class DownloadAssetPage extends StatefulWidget {
  const DownloadAssetPage({super.key});

  @override
  State<DownloadAssetPage> createState() => _DownloadAssetPageState();
}

class _DownloadAssetPageState extends State<DownloadAssetPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool isLoading = false;
  double onchainBalance = 10.0; // Assume the onchain balance is 10 ETH for demo

  String? publicKey;
  String? privateKey;

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    // Read the private and public keys securely from FlutterSecureStorage
    publicKey = await AppPrefSecureStorage.readPublicKey ?? 'No public key';
    privateKey = await AppPrefSecureStorage.readPrivateKey ?? 'No private key';
    setState(() {});
  }

  Future<void> _startDownload() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    double amount = double.parse(_amountController.text);

    // Simulate blockchain transfer process
    await Future.delayed(Duration(seconds: 3)); // Simulating time for ZK Proof

    setState(() {
      isLoading = false;
    });

    // Show success message
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Download Complete'),
          content: Text('$amount ETH transferred to your offchain wallet!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Download Assets')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Available Onchain Balance: $onchainBalance ETH',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter amount to transfer',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  double? amount = double.tryParse(value);
                  if (amount == null ||
                      amount <= 0 ||
                      amount > onchainBalance) {
                    return 'Enter a valid amount within balance';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _startDownload,
                  child: Text('Download to Device'),
                ),
              SizedBox(height: 40),
              if (publicKey != null)
                Text('Public Key: $publicKey', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
