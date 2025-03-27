import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animations/animations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

void main() {
  runApp(const HealthApp());
}

class HealthApp extends StatefulWidget {
  const HealthApp({super.key});

  @override
  _HealthAppState createState() => _HealthAppState();
}

class _HealthAppState extends State<HealthApp> {
  bool _isDarkMode = false;

  // Toggle dark mode.
  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  // Define light and dark themes.
  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[100],
    fontFamily: 'Georgia',
  );

  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    fontFamily: 'Georgia',
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health App',
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        isDarkMode: _isDarkMode,
        onToggleDarkMode: _toggleDarkMode,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleDarkMode;
  const HomeScreen({super.key, required this.isDarkMode, required this.onToggleDarkMode});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Updated pages: ProfilePage removed. Profile is now accessible via Settings.
  List<Widget> get _pages => [
        const HealthDashboard(),
        const SleepTrackingPage(),
        const NutritionPage(),
        const GoalsPage(),
        const ExerciseTrackingPage(),
        SettingsPage(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bedtime_rounded), label: "Sleep"),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu_rounded), label: "Nutrition"),
          BottomNavigationBarItem(icon: Icon(Icons.flag_rounded), label: "Goals"),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center_rounded), label: "Exercise"),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: "Settings"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
        selectedItemColor: widget.isDarkMode ? Colors.lightBlueAccent : Colors.blueAccent,
        unselectedItemColor: widget.isDarkMode ? Colors.grey[400] : Colors.grey,
      ),
    );
  }
}

class HealthDashboard extends StatelessWidget {
  const HealthDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample metrics data.
    int steps = 11000;
    int heartRate = 72;
    int calories = 500;
    double water = 2;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.health_and_safety, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Health Tracker",
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Dashboard summary with animated items.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AnimatedSummaryItem(
                imagePath: "assets/steps.png",
                label: "Steps",
                value: "$steps",
                targetPage: const StepsDetailPage(),
              ),
              AnimatedSummaryItem(
                imagePath: "assets/heart.png",
                label: "Heart",
                value: "$heartRate bpm",
                targetPage: const HeartDetailPage(),
              ),
              AnimatedSummaryItem(
                imagePath: "assets/calories.png",
                label: "Calories",
                value: "$calories kcal",
                targetPage: const CaloriesDetailPage(),
              ),
              AnimatedSummaryItem(
                imagePath: "assets/water.png",
                label: "Water",
                value: "${water}L",
                targetPage: const WaterDetailPage(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const DailyInsights(),
          const SizedBox(height: 20),
          const RecentActivity(),
        ],
      ),
    );
  }
}

class AnimatedSummaryItem extends StatelessWidget {
  final String? imagePath;
  final IconData? icon;
  final String label;
  final String value;
  final Widget targetPage;

  const AnimatedSummaryItem({
    super.key,
    this.imagePath,
    this.icon,
    required this.label,
    required this.value,
    required this.targetPage,
  });

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 500),
      closedElevation: 0,
      openElevation: 0,
      closedBuilder: (context, openContainer) {
        return InkWell(
          onTap: openContainer,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Shadowed circle.
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: imagePath != null
                    ? ClipOval(
                        child: Image.asset(
                          imagePath!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : (icon != null
                        ? Icon(icon, color: Colors.orange, size: 30)
                        : Container()),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
      openBuilder: (context, closeContainer) {
        return targetPage;
      },
    );
  }
}

class DailyInsights extends StatelessWidget {
  const DailyInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage("assets/daily_insight_bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Daily Insights",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Georgia',
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Keep up the great work! Every step counts. Stay active and hydrated for a healthier you.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      "Morning Walk: 5000 steps",
      "Afternoon Run: 7000 steps",
      "Evening Yoga: 30 mins",
      "Cycling: 15 km"
    ];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: AnimationLimiter(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Recent Activity",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: activities.map((activity) {
                    return ListTile(
                      leading: const Icon(Icons.fitness_center),
                      title: Text(activity),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepsDetailPage extends StatelessWidget {
  const StepsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<double> stepsData = [5000, 7000, 8000, 6000, 9000, 10000, 11000];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_walk, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Steps Details",
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnimatedChartWrapper(
            child: HealthBarChart(
              dataPoints: stepsData,
              title: "Weekly Steps",
            ),
          ),
          const SizedBox(height: 20),
          StepsDataInsights(stepsData: stepsData),
        ],
      ),
    );
  }
}

class HeartDetailPage extends StatelessWidget {
  const HeartDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<double> heartData = [70, 72, 68, 75, 73, 71, 69];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Heart Rate Details",
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnimatedChartWrapper(
            child: HealthBarChart(
              dataPoints: heartData,
              title: "Heart Rate (bpm)",
            ),
          ),
          const SizedBox(height: 20),
          HeartDataInsights(heartData: heartData),
        ],
      ),
    );
  }
}

class CaloriesDetailPage extends StatelessWidget {
  const CaloriesDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<double> calorieData = [500, 550, 520, 530, 560, 580, 570];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_fire_department_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Calories Burned Details",
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnimatedChartWrapper(
            child: HealthBarChart(
              dataPoints: calorieData,
              title: "Calories Burned",
            ),
          ),
          const SizedBox(height: 20),
          CaloriesDataInsights(calorieData: calorieData),
        ],
      ),
    );
  }
}

class WaterDetailPage extends StatelessWidget {
  const WaterDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<double> waterData = [2, 2.5, 2.0, 2.2, 2.8, 2.5, 2.7];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.water_drop_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Water Intake Details",
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnimatedChartWrapper(
            child: HealthBarChart(
              dataPoints: waterData,
              title: "Water Intake (L)",
            ),
          ),
          const SizedBox(height: 20),
          WaterDataInsights(waterData: waterData),
        ],
      ),
    );
  }
}

class AnimatedChartWrapper extends StatefulWidget {
  final Widget child;
  const AnimatedChartWrapper({super.key, required this.child});

  @override
  _AnimatedChartWrapperState createState() => _AnimatedChartWrapperState();
}

class _AnimatedChartWrapperState extends State<AnimatedChartWrapper> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(seconds: 1),
      opacity: _opacity,
      child: widget.child,
    );
  }
}

class HealthBarChart extends StatelessWidget {
  final List<double> dataPoints;
  final String title;

  const HealthBarChart({super.key, required this.dataPoints, required this.title});

  final Color firstColor = Colors.purple;
  final Color secondColor = Colors.blue;
  final Color thirdColor = Colors.cyan;
  final double betweenSpace = 0.2;

  BarChartGroupData generateGroupData(int x, double first, double second, double third) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: first,
          color: firstColor,
          width: 5,
        ),
        BarChartRodData(
          fromY: first + betweenSpace,
          toY: first + betweenSpace + second,
          color: secondColor,
          width: 5,
        ),
        BarChartRodData(
          fromY: first + betweenSpace + second + betweenSpace,
          toY: first + betweenSpace + second + betweenSpace + third,
          color: thirdColor,
          width: 5,
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mon';
        break;
      case 1:
        text = 'Tue';
        break;
      case 2:
        text = 'Wed';
        break;
      case 3:
        text = 'Thu';
        break;
      case 4:
        text = 'Fri';
        break;
      case 5:
        text = 'Sat';
        break;
      case 6:
        text = 'Sun';
        break;
      default:
        text = '';
    }
    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceBetween,
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: bottomTitles,
                    reservedSize: 20,
                  ),
                ),
              ),
              barTouchData: BarTouchData(enabled: false),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
              barGroups: List.generate(dataPoints.length, (index) {
                return generateGroupData(
                  index,
                  dataPoints[index] * 0.1,
                  dataPoints[index] * 0.2,
                  dataPoints[index] * 0.3,
                );
              }),
              maxY: dataPoints.reduce((a, b) => a > b ? a : b) + 1 + (betweenSpace * 3),
            ),
          ),
        ),
      ],
    );
  }
}

class StepsDataInsights extends StatelessWidget {
  final List<double> stepsData;

  const StepsDataInsights({super.key, required this.stepsData});

  @override
  Widget build(BuildContext context) {
    double avg = stepsData.reduce((a, b) => a + b) / stepsData.length;
    double min = stepsData.reduce((a, b) => a < b ? a : b);
    double max = stepsData.reduce((a, b) => a > b ? a : b);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Data Insights",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia')),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InsightItem(icon: Icons.bar_chart, label: "Avg", value: avg.toStringAsFixed(0)),
                InsightItem(icon: Icons.arrow_downward, label: "Min", value: min.toStringAsFixed(0)),
                InsightItem(icon: Icons.arrow_upward, label: "Max", value: max.toStringAsFixed(0)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HeartDataInsights extends StatelessWidget {
  final List<double> heartData;

  const HeartDataInsights({super.key, required this.heartData});

  @override
  Widget build(BuildContext context) {
    double avg = heartData.reduce((a, b) => a + b) / heartData.length;
    double min = heartData.reduce((a, b) => a < b ? a : b);
    double max = heartData.reduce((a, b) => a > b ? a : b);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Data Insights",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia')),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InsightItem(icon: Icons.bar_chart, label: "Avg", value: avg.toStringAsFixed(1)),
                InsightItem(icon: Icons.arrow_downward, label: "Min", value: min.toStringAsFixed(1)),
                InsightItem(icon: Icons.arrow_upward, label: "Max", value: max.toStringAsFixed(1)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CaloriesDataInsights extends StatelessWidget {
  final List<double> calorieData;

  const CaloriesDataInsights({super.key, required this.calorieData});

  @override
  Widget build(BuildContext context) {
    double avg = calorieData.reduce((a, b) => a + b) / calorieData.length;
    double min = calorieData.reduce((a, b) => a < b ? a : b);
    double max = calorieData.reduce((a, b) => a > b ? a : b);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Data Insights",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia')),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InsightItem(icon: Icons.bar_chart, label: "Avg", value: avg.toStringAsFixed(0)),
                InsightItem(icon: Icons.arrow_downward, label: "Min", value: min.toStringAsFixed(0)),
                InsightItem(icon: Icons.arrow_upward, label: "Max", value: max.toStringAsFixed(0)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WaterDataInsights extends StatelessWidget {
  final List<double> waterData;

  const WaterDataInsights({super.key, required this.waterData});

  @override
  Widget build(BuildContext context) {
    double avg = waterData.reduce((a, b) => a + b) / waterData.length;
    double min = waterData.reduce((a, b) => a < b ? a : b);
    double max = waterData.reduce((a, b) => a > b ? a : b);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Data Insights",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia')),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InsightItem(icon: Icons.bar_chart, label: "Avg", value: avg.toStringAsFixed(1)),
                InsightItem(icon: Icons.arrow_downward, label: "Min", value: min.toStringAsFixed(1)),
                InsightItem(icon: Icons.arrow_upward, label: "Max", value: max.toStringAsFixed(1)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InsightItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InsightItem({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.blue),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Georgia',
          ),
        ),
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onToggleDarkMode;

  const SettingsPage({super.key, required this.isDarkMode, required this.onToggleDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.settings, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Settings",
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey, Colors.blueGrey],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Card at the top.
          const ProfileCard(),
          const SizedBox(height: 20),
          // Customization options.
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text("Theme Selection", style: TextStyle(fontFamily: 'Georgia')),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Stub: Open theme selection dialog/screen.
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text("Primary Color", style: TextStyle(fontFamily: 'Georgia')),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Stub: Open primary color picker.
            },
          ),
          ListTile(
            leading: const Icon(Icons.brush),
            title: const Text("Accent Color", style: TextStyle(fontFamily: 'Georgia')),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Stub: Open accent color picker.
            },
          ),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text("Font Size", style: TextStyle(fontFamily: 'Georgia')),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Stub: Adjust font size.
            },
          ),
          ListTile(
            leading: const Icon(Icons.font_download),
            title: const Text("Font Family", style: TextStyle(fontFamily: 'Georgia')),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Stub: Choose font family.
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard Layout", style: TextStyle(fontFamily: 'Georgia')),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Stub: Change dashboard layout.
            },
          ),
          ListTile(
            leading: const Icon(Icons.widgets),
            title: const Text("Widget Arrangement", style: TextStyle(fontFamily: 'Georgia')),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Stub: Adjust widget arrangement.
            },
          ),
          ListTile(
            leading: const Icon(Icons.straighten),
            title: const Text("Unit Preferences", style: TextStyle(fontFamily: 'Georgia')),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Stub: Change unit preferences.
            },
          ),
          SwitchListTile(
            title: const Text(
              "Dark Mode",
              style: TextStyle(fontFamily: 'Georgia', fontSize: 18, fontWeight: FontWeight.bold),
            ),
            secondary: const Icon(Icons.dark_mode),
            value: isDarkMode,
            onChanged: onToggleDarkMode,
          ),
        ],
      ),
    );
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  String _name = "John Doe";
  int _age = 25;
  String _email = "johndoe@example.com";
  String _bio = "A fitness enthusiast who loves to stay active and healthy!";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = _name;
    _ageController.text = _age.toString();
    _emailController.text = _email;
    _bioController.text = _bio;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: "Age"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: _bioController,
                  decoration: const InputDecoration(labelText: "Bio"),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _name = _nameController.text;
                  _age = int.tryParse(_ageController.text) ?? _age;
                  _email = _emailController.text;
                  _bio = _bioController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage("assets/profile_placeholder.png"),
        ),
        title: Text(
          _name,
          style: const TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          _email,
          style: const TextStyle(fontFamily: 'Georgia'),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: _editProfile,
        ),
        onTap: _editProfile,
      ),
    );
  }
}


class SleepTrackingPage extends StatefulWidget {
  const SleepTrackingPage({super.key});

  @override
  _SleepTrackingPageState createState() => _SleepTrackingPageState();
}

class _SleepTrackingPageState extends State<SleepTrackingPage> {
  final List<String> _sleepLogs = [];
  final TextEditingController _sleepHoursController = TextEditingController();

  @override
  void dispose() {
    _sleepHoursController.dispose();
    super.dispose();
  }

  void _addSleepLog() {
    if (_sleepHoursController.text.isNotEmpty) {
      setState(() {
        _sleepLogs.add("Slept for ${_sleepHoursController.text} hours");
        _sleepHoursController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<double> sleepData = [7, 6.5, 8, 5, 7.5, 6, 8];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bedtime_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Sleep Tracking",
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _sleepHoursController,
                  decoration: const InputDecoration(
                    labelText: "Enter hours slept",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: _addSleepLog, child: const Icon(Icons.add)),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Sleep Log", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Georgia')),
          const Divider(),
          ..._sleepLogs.map((log) => ListTile(
                leading: const Icon(Icons.nightlight_round),
                title: Text(log),
              )),
          const SizedBox(height: 20),
          HealthBarChart(dataPoints: sleepData, title: "Sleep Hours Over Time"),
        ],
      ),
    );
  }
}

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  _NutritionPageState createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final List<String> _meals = [];
  final TextEditingController _mealController = TextEditingController();

  @override
  void dispose() {
    _mealController.dispose();
    super.dispose();
  }

  void _addMeal() {
    if (_mealController.text.isNotEmpty) {
      setState(() {
        _meals.add(_mealController.text);
        _mealController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Using a simple log recording UI.
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.restaurant_menu_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Nutrition",
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _mealController,
                  decoration: const InputDecoration(
                    labelText: "Enter your meal",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: _addMeal, child: const Icon(Icons.add)),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Meal Log", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Georgia')),
          const Divider(),
          ..._meals.map((meal) => ListTile(
                leading: const Icon(Icons.restaurant_menu),
                title: Text(meal),
              )),
        ],
      ),
    );
  }
}

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final List<String> _goals = [];
  final TextEditingController _goalController = TextEditingController();

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  void _addGoal() {
    if (_goalController.text.isNotEmpty) {
      setState(() {
        _goals.add(_goalController.text);
        _goalController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Goals page UI.
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flag_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Goals",
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.tealAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _goalController,
                  decoration: const InputDecoration(
                    labelText: "Enter your goal",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: _addGoal, child: const Icon(Icons.add)),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Goals Log", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Georgia')),
          const Divider(),
          ..._goals.map((goal) => ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text(goal),
              )),
        ],
      ),
    );
  }
}

class ExerciseTrackingPage extends StatefulWidget {
  const ExerciseTrackingPage({super.key});

  @override
  _ExerciseTrackingPageState createState() => _ExerciseTrackingPageState();
}

class _ExerciseTrackingPageState extends State<ExerciseTrackingPage> {
  final List<Map<String, dynamic>> exercises = [
    {'label': 'Running', 'icon': Icons.directions_run},
    {'label': 'Cycling', 'icon': Icons.pedal_bike},
    {'label': 'Yoga', 'icon': Icons.self_improvement},
    {'label': 'Strength', 'icon': Icons.fitness_center},
    {'label': 'Swimming', 'icon': Icons.pool},
  ];
  String selectedExercise = 'Running';

  int _secondsElapsed = 0;
  Timer? _timer;
  bool isRunning = false;
  List<String> sessionRecords = [];

  void _startTimer() {
    setState(() {
      isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      isRunning = false;
      _secondsElapsed = 0;
    });
  }

  void _recordSession() {
    String formattedTime = _formatTime(_secondsElapsed);
    setState(() {
      sessionRecords.add("$selectedExercise - $formattedTime");
      _secondsElapsed = 0;
      isRunning = false;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.fitness_center_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Exercise Tracking",
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                bool isSelected = exercise['label'] == selectedExercise;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedExercise = exercise['label'];
                      _resetTimer();
                    });
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.redAccent : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          exercise['icon'],
                          color: isSelected ? Colors.white : Colors.redAccent,
                          size: 28,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          exercise['label'],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.redAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Georgia',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Text(
                  _formatTime(_secondsElapsed),
                  style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Georgia'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: isRunning ? null : _startTimer,
                      child: const Text("Start"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: isRunning ? _pauseTimer : null,
                      child: const Text("Pause"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _resetTimer,
                      child: const Text("Reset"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _secondsElapsed > 0 ? _recordSession : null,
                  child: const Text("Record Session"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Exercise History",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 10),
          ...sessionRecords.map((record) => ListTile(
                leading: const Icon(Icons.history),
                title: Text(record),
              )),
        ],
      ),
    );
  }
}

class AnimatedChartWrappe extends StatefulWidget {
  final Widget child;
  const AnimatedChartWrappe({super.key, required this.child});

  @override
  _AnimatedChartWrapperState2 createState() => _AnimatedChartWrapperState2();
}

class _AnimatedChartWrapperState2 extends State<AnimatedChartWrappe> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(seconds: 1),
      opacity: _opacity,
      child: widget.child,
    );
  }
}

class HealthBarChart2 extends StatelessWidget {
  final List<double> dataPoints;
  final String title;

  const HealthBarChart2({super.key, required this.dataPoints, required this.title});

  final Color firstColor = Colors.purple;
  final Color secondColor = Colors.blue;
  final Color thirdColor = Colors.cyan;
  final double betweenSpace = 0.2;

  BarChartGroupData generateGroupData(int x, double first, double second, double third) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: first,
          color: firstColor,
          width: 5,
        ),
        BarChartRodData(
          fromY: first + betweenSpace,
          toY: first + betweenSpace + second,
          color: secondColor,
          width: 5,
        ),
        BarChartRodData(
          fromY: first + betweenSpace + second + betweenSpace,
          toY: first + betweenSpace + second + betweenSpace + third,
          color: thirdColor,
          width: 5,
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mon';
        break;
      case 1:
        text = 'Tue';
        break;
      case 2:
        text = 'Wed';
        break;
      case 3:
        text = 'Thu';
        break;
      case 4:
        text = 'Fri';
        break;
      case 5:
        text = 'Sat';
        break;
      case 6:
        text = 'Sun';
        break;
      default:
        text = '';
    }
    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceBetween,
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: bottomTitles,
                    reservedSize: 20,
                  ),
                ),
              ),
              barTouchData: BarTouchData(enabled: false),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
              barGroups: List.generate(dataPoints.length, (index) {
                return generateGroupData(
                  index,
                  dataPoints[index] * 0.1,
                  dataPoints[index] * 0.2,
                  dataPoints[index] * 0.3,
                );
              }),
              maxY: dataPoints.reduce((a, b) => a > b ? a : b) + 1 + (betweenSpace * 3),
            ),
          ),
        ),
      ],
    );
  }
}
