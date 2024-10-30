import 'package:flutter/material.dart';

void main() {
  runApp(BMICalculator());
}

class BMICalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BMIHomePage(),
    );
  }
}

class BMIHomePage extends StatefulWidget {
  @override
  _BMIHomePageState createState() => _BMIHomePageState();
}

class _BMIHomePageState extends State<BMIHomePage> {
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  String gender = 'Select Gender';
  String result = '';
  String status = '';
  double bmi = 0.0;

  // Function to calculate BMI
  void calculateBMI() {
    double height = double.parse(heightController.text) / 100; // Convert to meters
    double weight = double.parse(weightController.text);

    setState(() {
      bmi = weight / (height * height);
      result = 'BMI Calculated = ${bmi.toStringAsFixed(2)}';
      status = _getHealthStatus(bmi , gender);
    });
  }

  // Function to determine health status based on BMI
  String _getHealthStatus(double bmi, String gender) {
    if(gender == 'Female'){
      if (bmi < 18.5) {
        return 'Under Weight';
      } else if (bmi >= 18.5 && bmi < 25) {
        return 'Normal';
      } else {
        return 'Overweight';
      }
    }
    else{
      if (bmi < 16.5) {
        return 'Under Weight';
      } else if (bmi >= 18.5 && bmi < 27) {
        return 'Normal';
      } else {
        return 'Overweight';
      }
    }

  }

  // Function to reset all fields
  void resetFields() {
    setState(() {
      heightController.clear();
      weightController.clear();
      gender = 'Select Gender';
      result = '';
      status = '';
      bmi = 0.0;
    });
  }

  // Get avatar based on gender selection
  Widget _getGenderImage() {
    if (gender == 'Male') {
      return Image.network('https://icons.iconarchive.com/icons/custom-icon-design/flatastic-7/256/Male-icon.png', height: 150);
    } else if (gender == 'Female') {
      return Image.network('https://cdn2.iconfinder.com/data/icons/women-s-day-1/512/76_female_symbol_gender_women_womens_day-1024.png', height: 150);
    } else {
      return Icon(Icons.help_outline, size: 150);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Your Height (cm)',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Your Weight (kg)',
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: gender,
              items: ['Select Gender', 'Male', 'Female']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  gender = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            Center(child: _getGenderImage()),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.calculate),
              label: Text('Calculate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow
              ),
              onPressed: () {
                if (gender != 'Select Gender' &&
                    heightController.text.isNotEmpty &&
                    weightController.text.isNotEmpty) {
                  calculateBMI();
                } else {
                  // Alert if any field is empty or not selected
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Please enter all fields correctly.'),
                      ));
                }
              },
            ),
            SizedBox(height: 20),
            Text(result, style: TextStyle(fontSize: 18)),
            Text('Current Status = $status', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.refresh),
              label: Text('Reset'),
              onPressed: resetFields,
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow, // Background color
              ),
            ),
          ],
        ),
      ),
    );
  }
}