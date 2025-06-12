import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_micro_interactions/flutter_micro_interactions.dart' as micro;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Micro Interactions',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 18, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Micro Interactions'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.touch_app), text: 'Tap'),
            Tab(icon: Icon(Icons.smart_button), text: 'Button'),
            Tab(icon: Icon(Icons.auto_awesome), text: 'Hover'),
            Tab(icon: Icon(Icons.input), text: 'Input'),
            Tab(icon: Icon(Icons.refresh), text: 'Pull'),
            Tab(icon: Icon(Icons.swipe), text: 'Swipe'),
            Tab(icon: Icon(Icons.menu), text: 'Menu'),
            Tab(icon: Icon(Icons.layers), text: 'Parallax'),
            Tab(icon: Icon(Icons.vibration), text: 'Shake'),
            Tab(icon: Icon(Icons.transform), text: 'Morph'),
            Tab(icon: Icon(Icons.expand), text: 'Elastic'),
            Tab(icon: Icon(Icons.water_drop), text: 'Ripple'),
            Tab(icon: Icon(Icons.slideshow), text: 'Transition'),
            Tab(icon: Icon(Icons.view_agenda_outlined), text: 'Skeleton'),
            Tab(icon: Icon(Icons.notifications), text: 'Toast'),
            Tab(icon: Icon(Icons.label), text: 'Floating'),
            Tab(icon: Icon(Icons.reorder), text: 'Reorder'),
            Tab(icon: Icon(Icons.flip), text: 'Flip'),
          ],
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
        child: TabBarView(
          controller: _tabController,
          children: const [
            TapFeedbackTab(),
            ButtonStatesTab(),
            HoverGlowTab(),
            InputFocusTab(),
            PullToRefreshTab(),
            SwipeActionsTab(),
            LongPressMenuTab(),
            ParallaxScrollTab(),
            ShakeToActionTab(),
            MorphingShapesTab(),
            ElasticScrollTab(),
            RippleEffectTab(),
            PageTransitionsTab(),
            LoadingSkeletonsTab(),
            ToastNotificationsTab(),
            FloatingLabelTab(),
            ReorderableListTab(),
            CardFlipTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(
               content: Text('Thanks for trying Flutter Micro Interactions!'),
               behavior: SnackBarBehavior.floating,
             ),
           );
        },
        tooltip: 'Information',
        child: const Icon(Icons.info_outline),
      ),
    );
  }
}

// Tab Pages
class TapFeedbackTab extends StatelessWidget {
  const TapFeedbackTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Tap Effects',
            'Different animations for tactile feedback',
          ),
          const SizedBox(height: 24),
          
          _buildExampleCard(
            title: 'Scale',
            description: 'Element scales down when tapped',
            child: micro.TapFeedback.scale(
              onTap: () => _showSnackBar(context, 'Scale effect activated'),
              child: _buildDemoButton('Tap to scale', Icons.zoom_in),
            ),
          ),
          
          _buildExampleCard(
            title: 'Bounce',
            description: 'Elastic animation with bounce effect',
            child: micro.TapFeedback.bounce(
              onTap: () => _showSnackBar(context, 'Bounce effect activated'),
              child: _buildDemoButton('Tap to bounce', Icons.sports_basketball),
            ),
          ),
          
          _buildExampleCard(
            title: 'Fade',
            description: 'Element becomes semi-transparent',
            child: micro.TapFeedback.fade(
              onTap: () => _showSnackBar(context, 'Fade effect activated'),
              child: _buildDemoButton('Tap to fade', Icons.opacity),
            ),
          ),
          
          _buildExampleCard(
            title: 'Combined',
            description: 'Scale and opacity together',
            child: micro.TapFeedback.scaleAndOpacity(
              onTap: () => _showSnackBar(context, 'Combined effect activated'),
              child: _buildDemoButton('Combined effect', Icons.auto_awesome),
            ),
          ),
          
          _buildExampleCard(
            title: 'Custom',
            description: 'Advanced configuration with haptics',
            child: micro.TapFeedback(
              onTap: () => _showSnackBar(context, 'Custom effect activated'),
              scaleDown: 0.85,
              scaleUp: 1.05,
              opacity: 0.7,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOutBack,
              enableScale: true,
              enableOpacity: true,
              enableHaptics: true,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.deepPurple],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Custom',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          _buildExampleCard(
            title: 'With Card',
            description: 'Applied to complex elements',
            child: micro.TapFeedback.scale(
              onTap: () => _showSnackBar(context, 'Card tapped'),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: const Icon(Icons.touch_app, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                               'Interactive Card',
                               style: TextStyle(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 16,
                               ),
                             ),
                            SizedBox(height: 4),
                            Text(
                               'Tap this card to see the effect',
                               style: TextStyle(
                                 color: Colors.grey,
                                 fontSize: 14,
                               ),
                             ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonStatesTab extends StatelessWidget {
  const ButtonStatesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Button States',
            'Buttons with loading, success and error states',
          ),
          const SizedBox(height: 24),
          
          _buildExampleCard(
            title: 'Button with States',
            description: 'Demonstrates loading → success → reset',
            child: const ButtonStatesDemo(),
          ),
          
          _buildExampleCard(
            title: 'Button with Error',
            description: 'Simulates an operation error',
            child: const ButtonStatesErrorDemo(),
          ),
        ],
      ),
    );
  }
}

class HoverGlowTab extends StatelessWidget {
  const HoverGlowTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Glow Effect',
            'Elements that glow when hovering with cursor',
          ),
          const SizedBox(height: 24),
          
          _buildExampleCard(
            title: 'Button with Glow',
            description: 'Hover over the button',
            child: micro.HoverGlow(
              child: ElevatedButton.icon(
                onPressed: () => _showSnackBar(context, 'Glowing button pressed'),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Hover here'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ),
          
          _buildExampleCard(
            title: 'Card with Glow',
            description: 'Effect applied to a card',
            child: micro.HoverGlow(
              child: Card(
                elevation: 4,
                child: InkWell(
                  onTap: () => _showSnackBar(context, 'Glowing card tapped'),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Glowing Card',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'This card has a glow effect on hover',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InputFocusTab extends StatelessWidget {
  const InputFocusTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Input Animations',
            'Text fields with focus animations',
          ),
          const SizedBox(height: 24),
          
          _buildExampleCard(
            title: 'Animated Field',
            description: 'Tap the field to see the animation',
            child: micro.InputFocus.animate(
              child: const TextField(
                decoration: InputDecoration(
                  labelText: 'Full name',
                  hintText: 'Enter your name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          
          _buildExampleCard(
            title: 'Email with Validation',
            description: 'Email field with animation',
            child: micro.InputFocus.animate(
              child: const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email address',
                  hintText: 'example@email.com',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          
          _buildExampleCard(
            title: 'Password',
            description: 'Password field with animation',
            child: micro.InputFocus.animate(
              child: const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Demo Components
class ButtonStatesDemo extends StatefulWidget {
  const ButtonStatesDemo({super.key});

  @override
  State<ButtonStatesDemo> createState() => _ButtonStatesDemoState();
}

class _ButtonStatesDemoState extends State<ButtonStatesDemo> {
  late micro.ButtonStates _buttonStates;

  @override
  void initState() {
    super.initState();
    _buttonStates = micro.ButtonStates.withTransitions(
      onLoading: () => const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      ),
      onSuccess: () => const Icon(Icons.check, color: Colors.white),
      onError: () => const Icon(Icons.error, color: Colors.white),
      child: ElevatedButton.icon(
        onPressed: () async {
          _buttonStates.setLoading();
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            _buttonStates.setSuccess();
            await Future.delayed(const Duration(seconds: 1));
            if (mounted) {
              _buttonStates.reset();
            }
          }
        },
        icon: const Icon(Icons.send),
        label: const Text('Send Data'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buttonStates;
  }
}

class ButtonStatesErrorDemo extends StatefulWidget {
  const ButtonStatesErrorDemo({super.key});

  @override
  State<ButtonStatesErrorDemo> createState() => _ButtonStatesErrorDemoState();
}

class _ButtonStatesErrorDemoState extends State<ButtonStatesErrorDemo> {
  late micro.ButtonStates _buttonStates;

  @override
  void initState() {
    super.initState();
    _buttonStates = micro.ButtonStates.withTransitions(
      onLoading: () => const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      ),
      onSuccess: () => const Icon(Icons.check, color: Colors.white),
      onError: () => const Icon(Icons.error, color: Colors.white),
      child: ElevatedButton.icon(
        onPressed: () async {
          _buttonStates.setLoading();
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            _buttonStates.setError();
            await Future.delayed(const Duration(seconds: 2));
            if (mounted) {
              _buttonStates.reset();
            }
          }
        },
        icon: const Icon(Icons.cloud_upload),
        label: const Text('Upload File'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buttonStates;
  }
}

// Helper Functions
Widget _buildSectionHeader(String title, String description) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        description,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
    ],
  );
}

Widget _buildExampleCard({
  required String title,
  required String description,
  required Widget child,
}) {
  return Card(
    margin: const EdgeInsets.only(bottom: 20),
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Center(child: child),
        ],
      ),
    ),
  );
}

// Pull to Refresh Tab
class PullToRefreshTab extends StatefulWidget {
  const PullToRefreshTab({super.key});

  @override
  State<PullToRefreshTab> createState() => _PullToRefreshTabState();
}

class _PullToRefreshTabState extends State<PullToRefreshTab> {
  List<String> items = List.generate(20, (index) => 'Item ${index + 1}');

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      items = List.generate(20, (index) => 'Refreshed Item ${index + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: micro.PullToRefresh(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(items[index]),
              subtitle: const Text('Pull down to refresh'),
            );
          },
        ),
      ),
    );
  }
}

// Swipe Actions Tab
class SwipeActionsTab extends StatefulWidget {
  const SwipeActionsTab({super.key});

  @override
  State<SwipeActionsTab> createState() => _SwipeActionsTabState();
}

class _SwipeActionsTabState extends State<SwipeActionsTab> {
  List<String> items = List.generate(10, (index) => 'Swipeable Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return micro.SwipeActions(
            leftActions: [
              micro.SwipeAction(
                icon: Icons.favorite,
                backgroundColor: Colors.green,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Favorited ${items[index]}')),
                  );
                },
              ),
            ],
            rightActions: [
              micro.SwipeAction(
                icon: Icons.share,
                backgroundColor: Colors.blue,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Shared ${items[index]}')),
                  );
                },
              ),
              micro.SwipeAction(
                icon: Icons.delete,
                backgroundColor: Colors.red,
                onPressed: () {
                  setState(() {
                    items.removeAt(index);
                  });
                },
              ),
            ],
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(items[index]),
              subtitle: const Text('Swipe left or right for actions'),
            ),
          );
        },
      ),
    );
  }
}

// Long Press Menu Tab
class LongPressMenuTab extends StatelessWidget {
  const LongPressMenuTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionHeader(
              'Long Press Menu',
              'Long press on items to show context menus',
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(6, (index) {
                  return micro.LongPressMenu(
                    menuItems: [
                      micro.MenuItem.copy(),
                      micro.MenuItem.share(),
                      micro.MenuItem.edit(),
                      micro.MenuItem.delete(),
                    ],
                    onMenuItemSelected: (item) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item.title} selected')),
                      );
                    },
                    child: Card(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.image, size: 48),
                            const SizedBox(height: 8),
                            Text('Item ${index + 1}'),
                            const Text(
                              'Long press me',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Parallax Scroll Tab
class ParallaxScrollTab extends StatefulWidget {
  const ParallaxScrollTab({super.key});

  @override
  State<ParallaxScrollTab> createState() => _ParallaxScrollTabState();
}

class _ParallaxScrollTabState extends State<ParallaxScrollTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: micro.ParallaxContainer(
        layers: [
          micro.ParallaxLayer(
            parallaxFactor: 0.2,
            child: Container(
              height: 400,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          micro.ParallaxLayer(
            parallaxFactor: 0.5,
            child: Container(
              height: 200,
              margin: const EdgeInsets.only(top: 50),
              child: const Center(
                child: Text(
                  'Parallax Effect',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Scroll Item ${index + 1}'),
                subtitle: const Text('Notice the parallax effect above'),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Shake to Action Tab
class ShakeToActionTab extends StatefulWidget {
  const ShakeToActionTab({super.key});

  @override
  State<ShakeToActionTab> createState() => _ShakeToActionTabState();
}

class _ShakeToActionTabState extends State<ShakeToActionTab> {
  int shakeCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionHeader(
              'Shake to Action',
              'Shake your device to trigger actions',
            ),
            const SizedBox(height: 40),
            micro.ShakeToAction(
              onShake: () {
                setState(() {
                  shakeCount++;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Device shaken!')),
                );
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.vibration,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Shake Me!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Count: $shakeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            micro.ShakeButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Button pressed!')),
                );
              },
              child: const Text('Shake Button'),
            ),
          ],
        ),
      ),
    );
  }
}

// Morphing Shapes Tab
class MorphingShapesTab extends StatefulWidget {
  const MorphingShapesTab({super.key});

  @override
  State<MorphingShapesTab> createState() => _MorphingShapesTabState();
}

class _MorphingShapesTabState extends State<MorphingShapesTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionHeader(
              'Morphing Shapes',
              'Watch shapes transform smoothly',
            ),
            const SizedBox(height: 40),
            const micro.MorphingShapes(
              shapes: [
                micro.ShapeType.circle,
                micro.ShapeType.square,
                micro.ShapeType.triangle,
                micro.ShapeType.star,
              ],
              size: Size(150, 150),
              duration: Duration(seconds: 2),
              color: Colors.purple,
            ),
            const SizedBox(height: 40),
            const micro.ShapeMorph(
              fromShape: micro.ShapeType.circle,
              toShape: micro.ShapeType.square,
              size: Size(100, 100),
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}

// Elastic Scroll Tab
class ElasticScrollTab extends StatelessWidget {
  const ElasticScrollTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSectionHeader(
              'Elastic Scroll',
              'Experience bouncy scroll behavior',
            ),
          ),
          Expanded(
            child: micro.ElasticListView(
              children: List.generate(30, (index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.primaries[index % Colors.primaries.length],
                    child: Text('${index + 1}'),
                  ),
                  title: Text('Elastic Item ${index + 1}'),
                  subtitle: const Text('Scroll to feel the elastic effect'),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// Ripple Effect Tab
class RippleEffectTab extends StatefulWidget {
  const RippleEffectTab({super.key});

  @override
  State<RippleEffectTab> createState() => _RippleEffectTabState();
}

class _RippleEffectTabState extends State<RippleEffectTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionHeader(
              'Ripple Effects',
              'Tap to create beautiful ripple animations',
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  micro.RippleEffect(
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Tap Me',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  micro.RippleButton(
                    rippleColor: Colors.red,
                    onTap: () {  },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Ripple Button',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const micro.WaterRipple(
                    child: Card(
                      child: Center(
                        child: Text(
                          'Water Ripple',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Page Transitions Tab
class PageTransitionsTab extends StatelessWidget {
  const PageTransitionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionHeader(
              'Page Transitions',
              'Experience different page transition effects',
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildTransitionButton(
                    context,
                    'Fade Transition',
                    micro.PageTransitionType.fade,
                    Colors.blue,
                  ),
                  _buildTransitionButton(
                    context,
                    'Slide Transition',
                    micro.PageTransitionType.slideLeft,
                    Colors.green,
                  ),
                  _buildTransitionButton(
                    context,
                    'Scale Transition',
                    micro.PageTransitionType.scale,
                    Colors.orange,
                  ),
                  _buildTransitionButton(
                    context,
                    'Rotate Transition',
                    micro.PageTransitionType.rotate,
                    Colors.purple,
                  ),
                  _buildTransitionButton(
                    context,
                    'Size Transition',
                    micro.PageTransitionType.size,
                    Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransitionButton(
    BuildContext context,
    String title,
    micro.PageTransitionType type,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: const Icon(Icons.arrow_forward, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Text('Tap to see $title effect'),
        onTap: () {
          Navigator.push(
            context,
            micro.PageTransition(
              type: type,
              child: _DemoPage(title: title, color: color),
            ),
          );
        },
      ),
    );
  }
}

class _DemoPage extends StatelessWidget {
  final String title;
  final Color color;

  const _DemoPage({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: color.withValues(alpha: 0.1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 100,
                color: color,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Loading Skeletons Tab
class LoadingSkeletonsTab extends StatefulWidget {
  const LoadingSkeletonsTab({super.key});

  @override
  State<LoadingSkeletonsTab> createState() => _LoadingSkeletonsTabState();
}

class _LoadingSkeletonsTabState extends State<LoadingSkeletonsTab> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _toggleLoading();
  }

  void _toggleLoading() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          isLoading = !isLoading;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionHeader(
              'Loading Skeletons',
              'Skeleton screens while content loads',
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLoading = !isLoading;
                    });
                  },
                  child: Text(isLoading ? 'Show Content' : 'Show Skeleton'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return micro.SkeletonLoader(
                    loading: isLoading,
                    skeleton: const micro.ListItemSkeleton(),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.primaries[index % Colors.primaries.length],
                        child: Text('${index + 1}'),
                      ),
                      title: Text('Loaded Item ${index + 1}'),
                      subtitle: const Text('This content was loaded successfully'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildDemoButton(String text, IconData icon) {
  return ElevatedButton.icon(
    onPressed: null,
    icon: Icon(icon),
    label: Text(text),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  );
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

// Toast Notifications Tab
class ToastNotificationsTab extends StatelessWidget {
  const ToastNotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Toast Notifications',
            'Different styles of toast notifications',
          ),
          const SizedBox(height: 24),
          
          _buildExampleCard(
            title: 'Success Toast',
            description: 'Shows a success message',
            child: ElevatedButton(
              onPressed: () {
                context.showToast(
                  message: 'Operation completed successfully!',
                  type: micro.ToastType.success,
                );
              },
              child: const Text('Show Success Toast'),
            ),
          ),
          
          _buildExampleCard(
            title: 'Error Toast',
            description: 'Shows an error message',
            child: ElevatedButton(
              onPressed: () {
                context.showToast(
                  message: 'An error occurred!',
                  type: micro.ToastType.error,
                );
              },
              child: const Text('Show Error Toast'),
            ),
          ),
          
          _buildExampleCard(
            title: 'Info Toast',
            description: 'Shows an information message',
            child: ElevatedButton(
              onPressed: () {
                context.showToast(
                  message: 'Here is some information',
                  type: micro.ToastType.info,
                );
              },
              child: const Text('Show Info Toast'),
            ),
          ),
          
          _buildExampleCard(
            title: 'Warning Toast',
            description: 'Shows a warning message',
            child: ElevatedButton(
              onPressed: () {
                context.showToast(
                  message: 'Warning: This action cannot be undone',
                  type: micro.ToastType.warning,
                );
              },
              child: const Text('Show Warning Toast'),
            ),
          ),
        ],
      ),
    );
  }
}

// Floating Label Tab
class FloatingLabelTab extends StatelessWidget {
  const FloatingLabelTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Floating Labels',
            'Text fields with animated floating labels',
          ),
          const SizedBox(height: 24),
          
          _buildExampleCard(
            title: 'Basic Input',
            description: 'Simple floating label input',
            child: const micro.FloatingLabel(
              label: 'Username',
              hint: 'Enter your username',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          
          _buildExampleCard(
            title: 'Email Input',
            description: 'Email field with validation',
            child: micro.FloatingLabel(
              label: 'Email',
              hint: 'Enter your email',
              prefixIcon: const Icon(Icons.email),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ),
          
          _buildExampleCard(
            title: 'Password Input',
            description: 'Password field with validation',
            child: micro.FloatingLabel(
              label: 'Password',
              hint: 'Enter your password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: const Icon(Icons.visibility),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Reorderable List Tab
class ReorderableListTab extends StatefulWidget {
  const ReorderableListTab({super.key});

  @override
  State<ReorderableListTab> createState() => _ReorderableListTabState();
}

class _ReorderableListTabState extends State<ReorderableListTab> {
  final List<String> _items = List.generate(10, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: _buildSectionHeader(
            'Reorderable List',
            'Drag and drop to reorder items',
          ),
        ),
        Expanded(
          child: micro.ReorderableList(
            children: _items.map((item) => ListTile(
              title: Text(item),
              leading: const Icon(Icons.drag_handle),
            )).toList(),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = _items.removeAt(oldIndex);
                _items.insert(newIndex, item);
              });
            },
          ),
        ),
      ],
    );
  }
}

// Card Flip Tab
class CardFlipTab extends StatefulWidget {
  const CardFlipTab({super.key});

  @override
  State<CardFlipTab> createState() => _CardFlipTabState();
}

class _CardFlipTabState extends State<CardFlipTab> {
  bool _isFlipped = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Card Flip',
            'Flip cards with smooth animations',
          ),
          const SizedBox(height: 24),
          
          _buildExampleCard(
            title: 'Basic Flip',
            description: 'Simple card flip animation',
            child: Center(
              child: Card(
                child: Container(
                  width: 200,
                  height: 300,
                  padding: const EdgeInsets.all(16),
                  child: micro.CardFlip(
                    front: _buildCardFace(
                      'Front',
                      Icons.flip,
                      Colors.blue,
                    ),
                    back: _buildCardFace(
                      'Back',
                      Icons.flip_camera_ios,
                      Colors.green,
                    ),
                    isFlipped: _isFlipped,
                    onFlip: () {
                      setState(() {
                        _isFlipped = !_isFlipped;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFace(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap to flip',
            style: TextStyle(
              color: color.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}