import 'package:flutter/material.dart';

class OtherUserBlock extends StatefulWidget {
  final int friendId;
  final String friendNickname;
  final int friendUserLevel;
  final String mainPetAssetName;
  final int isSting;
  // final void Function(BuildContext, Function, String, String, String, String,
  //     {dynamic data}) showConfirmationDialog;

  const OtherUserBlock({
    Key? key,
    required this.friendId,
    required this.friendNickname,
    required this.friendUserLevel,
    required this.mainPetAssetName,
    required this.isSting,
    // required this.showConfirmationDialog,
  }) : super(key: key);

  @override
  State<OtherUserBlock> createState() => _OtherUserBlockState();
}

class _OtherUserBlockState extends State<OtherUserBlock> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 232,
        height: 70,
        child: Stack(
          children: [
            Positioned(
              top: 7,
              left: 20,
              child: Container(
                width: 222,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      spreadRadius: 0.3,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 34,
                        height: double.infinity,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      Container(
                        width: 124,
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'LV.${widget.friendUserLevel}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              widget.friendNickname,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   height: 48,
                      //   width: 2,
                      //   color: widget.isSting == 1
                      //       ? Colors.transparent
                      //       : Theme.of(context).primaryColorDark,
                      // ),
                      // InkWell(
                      //   onTap: () {
                      //     print('하하');
                      //   },
                      //   splashColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      //   child: Container(
                      //     width: 54,
                      //     height: double.infinity,
                      //     decoration: BoxDecoration(
                      //       color: widget.isSting == 1
                      //           ? Theme.of(context).shadowColor
                      //           : Colors.transparent,
                      //     ),
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       // crossAxisAlignment: CrossAxisAlignment.spaceEvenly,
                      //       children: [
                      //         Icon(
                      //           Icons.push_pin,
                      //           color: Colors.white,
                      //           size: 20,
                      //         ),
                      //         SizedBox(
                      //           height: 6,
                      //         ),
                      //         Text(
                      //           '찌르기',
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 11,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        flex: 2,
                        child: Stack(
                          children: [
                            Container(
                              width: 20,
                              height: double.infinity,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorDark,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                onTap: () {},
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      '친구신청',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 22,
              child: Container(
                width: 16,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.5),
                      spreadRadius: 0.3,
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 7,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage(
                        "lib/assets/images/samples/${widget.mainPetAssetName}.PNG"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).secondaryHeaderColor,
                    width: 4,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.5),
                      spreadRadius: 0.5,
                      blurRadius: 6,
                    ),
                  ],
                ),
                // child: Image.asset(
                //   'lib/assets/images/samples/cat5.jpg',
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
