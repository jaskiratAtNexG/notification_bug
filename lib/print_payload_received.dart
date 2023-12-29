import 'package:flutter/material.dart';

class PrintPayloadReceived extends StatefulWidget {
  final String payload;
  const PrintPayloadReceived({super.key, required this.payload});

  @override
  State<PrintPayloadReceived> createState() => _PrintPayloadReceivedState();
}

class _PrintPayloadReceivedState extends State<PrintPayloadReceived> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Print payload received"),
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(child: Text(widget.payload),)),
    );
  }
}