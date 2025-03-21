import 'package:flutter/material.dart';
import 'package:solosafe/screens/home_page/widgets/send_receive.dart';

class LatestTransactions extends StatefulWidget {
  const LatestTransactions({super.key});

  @override
  State<LatestTransactions> createState() => _LatestTransactionsState();
}

class _LatestTransactionsState extends State<LatestTransactions> {
  final List<Map<String, String>> _offlineTransactions = [
    {'amount': '0.5 USDT', 'status': 'Confirmed', 'time': '2 hrs ago'},
    {'amount': '0.2 USDT', 'status': 'Wait', 'time': '5 hrs ago'},
    {'amount': '1.0 USDT', 'status': 'Offline', 'time': '1 day ago'},
  ];

  final List<Map<String, String>> _onlineTransactions = [
    {'amount': '0.8 USDT', 'type': 'Received', 'time': '4 hrs ago'},
    {'amount': '0.3 USDT', 'type': 'Sent', 'time': '10 hrs ago'},
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: 'Offline Transactions'),
                Tab(text: 'Online Transactions'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 15),
                      SendReceive(
                        sendType: 'offline',
                      ),
                      SizedBox(height: 15),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _offlineTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction = _offlineTransactions[index];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: Icon(
                                  Icons.offline_bolt,
                                  color: Colors.grey,
                                ),
                                title: Text(
                                  "${transaction['amount']}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "${transaction['status']} - ${transaction['time']}",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 15),
                      SendReceive(
                        sendType: 'online',
                      ),
                      SizedBox(height: 15),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _onlineTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction = _onlineTransactions[index];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: Icon(
                                  transaction['type'] == 'Received'
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: transaction['type'] == 'Received'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                title: Text(
                                  "${transaction['amount']}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "${transaction['type']} - ${transaction['time']}",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // Offline Transactions Tab
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
