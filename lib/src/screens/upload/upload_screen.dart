import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cie_photo_clash/src/blocs/auth/auth_bloc.dart';
import 'package:cie_photo_clash/src/blocs/data/data_bloc.dart';
import 'package:cie_photo_clash/src/model/post.dart';
import 'package:cie_photo_clash/src/utils/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatelessWidget {
  final ValueNotifier<File?> imageAvailableNotifier = ValueNotifier(null);
  final ValueNotifier<String> error = ValueNotifier('');

  final picker = ImagePicker();

  final titleTextController = TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File _image = File(pickedFile.path);
      imageAvailableNotifier.value = _image;
      error.value = '';
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'upload',
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              color: Theme.of(context).iconTheme.color,
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close)),
          elevation: 0.0,
          title: Text(
            'New Photo Upload',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          // width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.6,
                          child: InkWell(
                            onTap: getImage,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(8.0),
                              color: Theme.of(context).colorScheme.secondary,
                              strokeWidth: 1,
                              child: Stack(
                                children: [
                                  Align(
                                      alignment: Alignment.center,
                                      child: UploadIcon()),
                                  ValueListenableBuilder<File?>(
                                      valueListenable: imageAvailableNotifier,
                                      builder: (context, value, child) {
                                        return value != null
                                            ? Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image:
                                                            FileImage(value))),
                                              )
                                            : SizedBox.shrink();
                                      })
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        ValueListenableBuilder<String>(
                          valueListenable: error,
                          builder: (context, value, child) => Text(
                            value,
                            style: TextStyle(
                                color: Colors.red, fontStyle: FontStyle.italic),
                          ),
                        ),
                        SizedBox(
                          height: 32.0,
                        ),
                        TextFormField(
                          controller: titleTextController,
                          decoration: Constants.inputDecoration(context)
                              .copyWith(
                                  hintText: 'Enter title (optional)',
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary)),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                          // validator: MultiValidator([
                          //   RequiredValidator(errorText: 'CVC is required'),
                          //   MinLengthValidator(3,
                          //       errorText:
                          //           'CVC must be at least 4 digits long'),
                          //   MaxLengthValidator(4,
                          //       errorText: 'CVC must be at least 4 digits long')
                          // ]),
                          maxLength: 30,
                          maxLines: 2,
                          keyboardType: TextInputType.multiline,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    BlocConsumer<DataBloc, DataState>(
                      listener: (context, state) {
                        if (state is PostSavingState) {
                          showDialog(
                            context: context,
                            builder: (context) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SpinKitThreeBounce(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 45,
                                ),
                                Text('Uploading Image...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ))
                              ],
                            ),
                          );
                        }
                        if (state is PostSavedState) {
                          Navigator.of(context).pop();
                          AwesomeDialog(
                                  context: context,
                                  title: 'Success!',
                                  dialogType: DialogType.SUCCES,
                                  headerAnimationLoop: false,
                                  body: Text(
                                    'Image has been uploaded successfully',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                  ),
                                  dialogBackgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  btnOk: MaterialButton(
                                      padding: EdgeInsets.all(12.0),
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Text('Dismiss'),
                                      onPressed: () {
                                        Navigator.of(context)..pop()..pop();
                                      }),
                                  dismissOnTouchOutside: false,
                                  dismissOnBackKeyPress: false)
                              .show();
                        }
                        if (state is PostSaveErrorState) {
                          Navigator.of(context).pop();
                          AwesomeDialog(
                            context: context,
                            title: 'Failed',
                            dialogType: DialogType.ERROR,
                            headerAnimationLoop: false,
                            dialogBackgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            body: Text(
                              state.error,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                            btnOk: MaterialButton(
                                padding: EdgeInsets.all(12.0),
                                textColor:
                                    Theme.of(context).colorScheme.secondary,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Text('Dismiss'),
                                onPressed: () {
                                  Navigator.of(context)..pop()..pop();
                                }),
                          ).show();
                        }
                      },
                      builder: (context, state) {
                        return MaterialButton(
                          color: Theme.of(context).colorScheme.secondary,
                          padding: EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          onPressed: () {
                            if (imageAvailableNotifier.value != null) {
                              context.read<DataBloc>().add(AddPostEvent(
                                  Post(
                                      id: '',
                                      imagePath: '',
                                      title: titleTextController.text.isEmpty
                                          ? 'CIE Photo Clash'
                                          : titleTextController.text,
                                      timestamp:
                                          DateTime.now().millisecondsSinceEpoch,
                                      userId: AuthBloc.uid,
                                      voteId: ''),
                                  imageAvailableNotifier.value!));
                            } else {
                              error.value = "Please select an image";
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/upload.png',
                                width: 32.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              Text(
                                'Upload',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UploadIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: getImage,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_sharp,
              color: Theme.of(context).colorScheme.secondary,
              size: 100,
            ),
            Text(
              'Tap to choose file',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            )
          ],
        ),
      ),
    );
  }
}
