import 'package:flutter/material.dart';

import '../theme.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  bool ans1 = false;
  bool ans2 = false;
  bool ans3 = false;
  bool ans4 = false;
  bool ans5 = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                      fontFamily: 'Outfit-Bold', fontSize: size.width * .06),
                ),
                SizedBox(
                  height: size.height * .01,
                ),
                Divider(thickness: 2),
                SizedBox(
                  height: size.height * .01,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      ans1 ? ans1 = false : ans1 = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    width: size.width * .9,
                    decoration: BoxDecoration(
                      color: lightgrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'What is considered as excessive bleeding during menstruation?',
                            style: TextStyle(
                                fontFamily: 'Outfit-Regular',
                                fontSize: size.width * .04),
                          ),
                        ),
                        Icon(ans1 ? Icons.arrow_drop_up : Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: ans1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      width: size.width * .9,
                      decoration: BoxDecoration(
                        color: lightgrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Expanded(
                        child: Text(
                          'Excessive bleeding during menstruation is defined as losing 80 mL or more of blood per cycle or soaking through one or more menstrual products every hour for several consecutive hours.',
                          style: TextStyle(
                              fontFamily: 'Outfit-Regular',
                              fontSize: size.width * .04,
                              color: mainRed),
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height*.015,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      ans2 ? ans2 = false : ans2 = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    width: size.width * .9,
                    decoration: BoxDecoration(
                      color: lightgrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'What are the causes of heavy menstrual bleeding?',
                            style: TextStyle(
                                fontFamily: 'Outfit-Regular',
                                fontSize: size.width * .04),
                          ),
                        ),
                        Icon(ans2 ? Icons.arrow_drop_up : Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: ans2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      width: size.width * .9,
                      decoration: BoxDecoration(
                        color: lightgrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Expanded(
                        child: Text(
                          'The causes of heavy menstrual bleeding include hormonal imbalances, uterine fibroids, endometrial hyperplasia, thyroid disorders, polyps, adhesions, pregnancy complications, and some medications.',
                          style: TextStyle(
                              fontFamily: 'Outfit-Regular',
                              fontSize: size.width * .04,
                              color: mainRed),
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height*.015,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      ans3 ? ans3 = false : ans3 = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    width: size.width * .9,
                    decoration: BoxDecoration(
                      color: lightgrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'How can heavy menstrual bleeding be managed or treated?',
                            style: TextStyle(
                                fontFamily: 'Outfit-Regular',
                                fontSize: size.width * .04),
                          ),
                        ),
                        Icon(ans3 ? Icons.arrow_drop_up : Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: ans3,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      width: size.width * .9,
                      decoration: BoxDecoration(
                        color: lightgrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Expanded(
                        child: Text(
                          'Treatment options for heavy menstrual bleeding include hormonal birth control, non-steroidal anti-inflammatory drugs (NSAIDs), tranexamic acid, endometrial ablation, and uterine artery embolization. In severe cases, surgery may be necessary',
                          style: TextStyle(
                              fontFamily: 'Outfit-Regular',
                              fontSize: size.width * .04,
                              color: mainRed),
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
