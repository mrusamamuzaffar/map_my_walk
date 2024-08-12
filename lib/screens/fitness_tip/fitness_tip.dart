// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import '../../configs/app.dart';
// import '../../configs/app_theme.dart';
// import '../../configs/space.dart';
// import '../../providers/app_provider.dart';
// import '../../widgets/buttons/app_button.dart';
// import '../../widgets/dividers/app_dividers.dart';
// import '../../widgets/text_fields/custom_text_field.dart';
//
// class FitnessTipScreen extends StatefulWidget {
//   const FitnessTipScreen({Key? key}) : super(key: key);
//
//   @override
//   _FitnessTipScreenState createState() => _FitnessTipScreenState();
// }
//
// class _FitnessTipScreenState extends State<FitnessTipScreen> {
//   bool _isLoading = false;
//   String _recommendations = '';
//   final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
//
//   final GenerativeModel model = GenerativeModel(
//       model: 'gemini-pro',
//       apiKey: "AIzaSyAcODqO3muGpih3AISgU4Dr7hZfFm3GWqU" // Replace with your actual API key.
//   );
//
//   Future<void> fetchDietRecommendations(int age, double height, double weight) async {
//     setState(() => _isLoading = true);
//     final content = [
//       Content.text('Age: $age, Height: $height, Weight: $weight with this info give me diet suggestions both to lose weight and to gain weight')
//     ];
//     try {
//       final response = await model.generateContent(content);
//       setState(() {
//         _recommendations = response.text ?? 'No recommendations found';
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _recommendations = 'Error fetching recommendations: $e';
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     App.init(context);
//     ScreenUtil.init(context, designSize: const Size(428, 926));
//
//     return Scaffold(
//       appBar: AppBar(),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(20.0),
//             child: FormBuilder(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   Text('Diet recommender', style: Theme.of(context).textTheme.headline4),
//                   SizedBox(height: 20),
//                   Text('Get one of the best diets from our best machine learning models to keep you in shape!', style: Theme.of(context).textTheme.subtitle1),
//                   SizedBox(height: 20),
//                   CustomTextField(name: 'age', hint: 'Enter your age', textInputType: TextInputType.number, validators: FormBuilderValidators.required()),
//                   SizedBox(height: 20),
//                   CustomTextField(name: 'height', hint: 'Enter your height (ft)', textInputType: TextInputType.number, validators: FormBuilderValidators.required()),
//                   SizedBox(height: 20),
//                   CustomTextField(name: 'weight', hint: 'Enter your weight (KG)', textInputType: TextInputType.number, validators: FormBuilderValidators.required()),
//                   SizedBox(height: 20),
//                   AppButton(
//                     onPressed: () {
//                       if (_formKey.currentState?.saveAndValidate() ?? false) {
//                         FocusScope.of(context).unfocus();
//                         final age = int.parse(_formKey.currentState?.fields['age']?.value.toString().trim() ?? '0');
//                         final height = double.parse(_formKey.currentState?.fields['height']?.value.toString().trim() ?? '0');
//                         final weight = double.parse(_formKey.currentState?.fields['weight']?.value.toString().trim() ?? '0');
//                         fetchDietRecommendations(age, height, weight);
//                       }
//                     },
//                     child: Text('Get Diet', style: TextStyle(color: Colors.white)),
//                   ),
//                   if (_isLoading)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 20),
//                       child: Center(child: CircularProgressIndicator()),
//                     ),
//                   if (_recommendations.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         _recommendations,
//                         style: Theme.of(context).textTheme.subtitle1,
//                       ),
//                     ),
//                   Divider(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import '../../configs/app.dart';
import '../../configs/app_theme.dart';
import '../../widgets/buttons/app_button.dart';
import '../../widgets/dividers/app_dividers.dart';
import '../../widgets/text_fields/custom_text_field.dart';

class FitnessTipScreen extends StatefulWidget {
  const FitnessTipScreen({Key? key}) : super(key: key);

  @override
  _FitnessTipScreenState createState() => _FitnessTipScreenState();
}

class _FitnessTipScreenState extends State<FitnessTipScreen> {
  bool _isLoading = false;
  String _recommendations = '';
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final GenerativeModel model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: "AIzaSyAcODqO3muGpih3AISgU4Dr7hZfFm3GWqU" // Replace with your actual API key.
  );

  Future<void> fetchDietRecommendations(int age, double height, double weight) async {
    setState(() => _isLoading = true);
    final content = [
      Content.text('Age: $age, Height: $height, Weight: $weight with this info calculate my BMI and show me the score accordingly also show me which category i fall in also give me diet suggestions according to the BMI either to lose weight or gain')
    ];
    try {
      final response = await model.generateContent(content);
      setState(() {
        _recommendations = response.text ?? 'No recommendations found';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _recommendations = 'Error fetching recommendations: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> saveAndOpenPdf(String text) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(text),
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/DietRecommendations.pdf");
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    ScreenUtil.init(context, designSize: const Size(428, 926));

    return Scaffold(
      appBar: AppBar(
        title: Text("Recommendation"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('Diet recommender', style: Theme.of(context).textTheme.headline4),
                  SizedBox(height: 10),
                  Text('Get one of the best diets from our best machine learning models to keep you in shape!', style: Theme.of(context).textTheme.bodySmall),
                  SizedBox(height: 10),
                  CustomTextField(
                    name: 'age',
                    hint: 'Enter your age',
                    textInputType: TextInputType.number,
                    validators: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.min(18, errorText: "Age must be at least 18"),
                    ]),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    name: 'height',
                    hint: 'Enter your height (ft)',
                    textInputType: TextInputType.number,
                    validators: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.min(3, errorText: "Height must be at least 3 ft"),
                    ]),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    name: 'weight',
                    hint: 'Enter your weight (KG)',
                    textInputType: TextInputType.number,
                    validators: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.min(30, errorText: "Weight must be at least 30 KG"),
                    ]),
                  ),
                  SizedBox(height: 20),
                  AppButton(
                    onPressed: () {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        FocusScope.of(context).unfocus();
                        final age = int.parse(_formKey.currentState?.fields['age']?.value.toString().trim() ?? '0');
                        final height = double.parse(_formKey.currentState?.fields['height']?.value.toString().trim() ?? '0');
                        final weight = double.parse(_formKey.currentState?.fields['weight']?.value.toString().trim() ?? '0');
                        fetchDietRecommendations(age, height, weight);
                      }
                    },
                    child: Text('Get Diet', style: TextStyle(color: Colors.white)),
                  ),
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (_recommendations.isNotEmpty)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _recommendations,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => saveAndOpenPdf(_recommendations),
                          child: const Text('Download PDF'),
                        ),
                      ],
                    ),
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
