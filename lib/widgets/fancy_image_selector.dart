import 'package:flutter/material.dart';

class FancyImageSelector extends StatefulWidget {
  final List<String> images;
  final Function onChange;
  final Color btnColorSelected;
  final Color btnColorUnselected;
  final Color btnTextColorSelected;
  final Color btnTextColorUnselected;
  final Color bgGradientComparisonColor;
  final String assetURL;
  final String initValue;
  FancyImageSelector({this.images, this.onChange,
    this.btnColorSelected, this.btnColorUnselected,
    this.btnTextColorSelected, this.btnTextColorUnselected,
    this.bgGradientComparisonColor, this.assetURL,
    this.initValue});

  @override
  _FancyImageSelectorState createState() => _FancyImageSelectorState();
}

class _FancyImageSelectorState extends State<FancyImageSelector> {
  String selectedImage;
  @override
  void initState() {
    super.initState();
    if(widget.initValue != null){
      setState(() {
        selectedImage = widget.initValue;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    List<Widget> mainContent = this.widget.images.map((image){
      return Container(
        width: screenWidth / 1.5,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              widget.bgGradientComparisonColor,
              Color.lerp(Colors.grey[700], widget.bgGradientComparisonColor, 0.5),
              Colors.grey[850]
            ],
            center: Alignment(0.6, -0.3),
            focal: Alignment(0.3, -0.1),
            focalRadius: 3.5,
          ),
          borderRadius: BorderRadius.circular(25)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 24),
              child: ClipRRect(
                child: Image.network(
                    "${widget.assetURL}/$image",
                    height: 150,
                    width: 150,
                    fit: BoxFit.fitHeight,
                ),
                borderRadius: BorderRadius.circular(300),
              ),
            ),
            Container(
              height: screenHeight / 11.25,
              width: screenWidth,
              child: TextButton(
                child: Text(
                    'Select',
                    style: TextStyle(
                      color: selectedImage == image ? widget.btnTextColorSelected : widget.btnTextColorUnselected,
                      fontSize: 24
                    ),
                ),
                onPressed: (){
                  setState(() {
                    //update view
                    selectedImage = image;
                    //update parent
                    widget.onChange(image);
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: selectedImage == image ? widget.btnColorSelected : widget.btnColorUnselected,
                  shadowColor: Colors.black,
                  shape: ContinuousRectangleBorder(),
                  elevation: 12
                ),
              ),
            )
          ],
        ),
      );
    }).toList();
    return Container(
      height: 250,
      width: screenWidth,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: mainContent,
      ),
    );
  }
}
