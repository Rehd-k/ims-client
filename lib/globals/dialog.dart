import 'package:flutter/material.dart';

void openBox(BuildContext context, doDelete) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Container(
            width: 2,
            padding: EdgeInsets.all(0),
            child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 120, maxHeight: 140),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 5),
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Column(
                              children: [
                                Text(
                                    textAlign: TextAlign.center,
                                    "Are You Sure, This Process Is Irrivocable and may cause Accounting Issues To Continue Press Ok"),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Divider(),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                                color: Colors.lightBlue,
                                                width: 1),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text('Cancel'),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      })),
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                                width: 1),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      onTap: () async {
                                        await doDelete();
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                      })),
                            ],
                          )
                        ]),
                  ),
                ))),
      );
    },
  );
}
