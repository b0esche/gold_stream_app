import 'package:flutter/material.dart';
import 'package:gold_stream_app/src/gold/data/fake_gold_api.dart';
import 'package:gold_stream_app/src/gold/presentation/widgets/gold_header.dart';
import 'package:intl/intl.dart';

class GoldScreen extends StatefulWidget {
  const GoldScreen({super.key});

  @override
  State<GoldScreen> createState() => _GoldScreenState();
}

class _GoldScreenState extends State<GoldScreen> {
  late final Stream<double> goldStream;
  @override
  void initState() {
    super.initState();
    goldStream = getGoldPriceStream();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoldHeader(),
              SizedBox(height: 20),
              Text(
                'Live Kurs:',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 20),
              StreamBuilder<double>(
                stream: goldStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final price = snapshot.data!;
                    return Text(
                      NumberFormat.simpleCurrency(
                        locale: 'de_DE',
                      ).format(price),
                      style: Theme.of(context).textTheme.headlineLarge!
                          .copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text("Fehler beim Laden");
                  } else {
                    return const Text("Keine Daten verfügbar");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
