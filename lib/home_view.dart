import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AutoScrollController _scrollController = AutoScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _galleryKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  Future _scrollToIndex(int index) async {
    await _scrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );
  }

  // A small helper to build navigation items with hover effect
  Widget _buildNavItem(String title, int index) {
    return _HoverText(
      text: title,
      onTap: () => _scrollToIndex(index),
      style: Theme.of(
        context,
      ).textTheme.titleMedium!.copyWith(color: Colors.white),
      hoverStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Theme.of(context).colorScheme.secondary,
        decoration: TextDecoration.underline,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: _ResponsiveAppBar(
          scrollController: _scrollController,
          onNavSelected: (index) => _scrollToIndex(index),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            AutoScrollTag(
              key: _homeKey,
              controller: _scrollController,
              index: 0,
              child: const HeroSection(),
            ),
            AutoScrollTag(
              key: _aboutKey,
              controller: _scrollController,
              index: 1,
              child: const AboutSection(),
            ),
            AutoScrollTag(
              key: _galleryKey,
              controller: _scrollController,
              index: 2,
              child: const GallerySection(),
            ),
            AutoScrollTag(
              key: _contactKey,
              controller: _scrollController,
              index: 3,
              child: const ContactSection(),
            ),
            // Footer (optional)
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.black,
              child: Text(
                '© ${DateTime.now().year} Your Name. All rights reserved.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A simple widget for handling text hover effects with shadow
class _HoverText extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final TextStyle? style;
  final TextStyle? hoverStyle; // Still useful for color/font changes

  const _HoverText({
    required this.text,
    required this.onTap,
    this.style,
    this.hoverStyle,
  });

  @override
  State<_HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<_HoverText> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer( // Wrap Text in AnimatedContainer for shadow transition
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), // Small padding to make shadow visible
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), // Slightly rounded corners for shadow
            boxShadow: _isHovering
                ? [
              BoxShadow(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.4), // White shadow
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 0), // Centered shadow
              ),
            ]
                : [],
          ),
          child: Text(
            widget.text,
            style: _isHovering ? widget.hoverStyle : widget.style,
          ),
        ),
      ),
    );
  }
}

// ... (rest of the file: _ResponsiveAppBar class etc.)
// Responsive App Bar
class _ResponsiveAppBar extends StatelessWidget {
  final AutoScrollController scrollController;
  final Function(int) onNavSelected;

  const _ResponsiveAppBar({
    required this.scrollController,
    required this.onNavSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _HoverText(
        text: 'MOHAB MOSALAM',
        onTap: () => onNavSelected(0),
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: Theme.of(context).colorScheme.secondary,
        ),
        hoverStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
        ),
      ),
      actions: _buildNavItems(context),
    );
  }

  List<Widget> _buildNavItems(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;
    if (isDesktop) {
      return [
        _buildNavItem('HOME', 0, context),
        const SizedBox(width: 20),
        _buildNavItem('ABOUT', 1, context),
        const SizedBox(width: 20),
        _buildNavItem('GALLERY', 2, context),
        const SizedBox(width: 20),
        _buildNavItem('CONTACT', 3, context),
        const SizedBox(width: 20),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _showMobileDrawer(context);
          },
        ),
      ];
    }
  }

  Widget _buildNavItem(String title, int index, BuildContext context) {
    return _HoverText(
      text: title,
      onTap: () => onNavSelected(index),
      style: Theme.of(
        context,
      ).textTheme.titleMedium!.copyWith(color: Colors.white),
      hoverStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  void _showMobileDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                'HOME',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              onTap: () {
                onNavSelected(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'ABOUT',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              onTap: () {
                onNavSelected(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'GALLERY',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              onTap: () {
                onNavSelected(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'CONTACT',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              onTap: () {
                onNavSelected(3);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          MediaQuery.of(context).size.height * 0.9, // Almost full screen height
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MOHAB MOSALAM',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'PHOTOGRAPHER | VISUAL ARTIST',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                letterSpacing: 3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      constraints: const BoxConstraints(maxWidth: 900), // Max width for content
      child: Column(
        children: [
          Text(
            'ABOUT ME',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          MediaQuery.of(context).size.width > 700
              ? _buildDesktopLayout(context)
              : _buildMobileLayout(context),
          const SizedBox(height: 40),
          // Optional: Add social media links or a small "Hire me" button
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: CircleAvatar(
            radius: 150,
            backgroundImage: AssetImage(
              'assets/images/mohab.jpeg', // Replace with your profile pic
            ),
          ),
        ),
        const SizedBox(width: 50),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Journey in Photography',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Text(
                'Hello! I\'m [Your Name], a passionate photographer specializing in [e.g., landscape, portrait, event] photography. Based in [Your City], I strive to capture moments that tell a story, evoke emotion, and stand the test of time.\n\nMy journey began [e.g., X years ago] with a simple camera and a love for exploring the world through a lens. Today, I combine technical precision with artistic vision to create stunning visuals for my clients and personal projects. Let\'s create something beautiful together!',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Image.asset(
            'assets/images/mohab.jpeg', // Replace with your profile pic
            width: 180,
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'My Journey in Photography',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          'Hello! I\'m [Your Name], a passionate photographer specializing in [e.g., landscape, portrait, event] photography. Based in [Your City], I strive to capture moments that tell a story, evoke emotion, and stand the test of time.\n\nMy journey began [e.g., X years ago] with a simple camera and a love for exploring the world through a lens. Today, I combine technical precision with artistic vision to create stunning visuals for my clients and personal projects. Let\'s create something beautiful together!',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class GallerySection extends StatefulWidget {
  const GallerySection({super.key});

  @override
  State<GallerySection> createState() => _GallerySectionState();
}

class _GallerySectionState extends State<GallerySection> {
  final List<String> _imagePaths = [
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/3.jpg',
    'assets/images/4.jpg',
    'assets/images/5.jpg',
    'assets/images/6.jpg',
    'assets/images/7.jpg',
    'assets/images/mohab.jpeg',
    // Add more image paths here
  ];

  String? _hoveredImagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        children: [
          Text(
            'GALLERY',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 1;
              if (constraints.maxWidth > 1200) {
                crossAxisCount = 4;
              } else if (constraints.maxWidth > 800) {
                crossAxisCount = 3;
              } else if (constraints.maxWidth > 500) {
                crossAxisCount = 2;
              }

              return GridView.builder(
                shrinkWrap: true,
                // Important for nested scroll views
                physics: const NeverScrollableScrollPhysics(),
                // Prevent GridView from scrolling independently
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1, // Square images
                ),
                itemCount: _imagePaths.length,
                itemBuilder: (context, index) {
                  return _GalleryImageItem(
                    imagePath: _imagePaths[index],
                    onHover: (isHovering) {
                      setState(() {
                        _hoveredImagePath =
                            isHovering ? _imagePaths[index] : null;
                      });
                    },
                    isHovered: _hoveredImagePath == _imagePaths[index],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GalleryImageItem extends StatelessWidget {
  final String imagePath;
  final Function(bool) onHover;
  final bool isHovered;

  const _GalleryImageItem({
    required this.imagePath,
    required this.onHover,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          boxShadow:
              isHovered
                  ? [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                  : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      constraints: const BoxConstraints(maxWidth: 900),
      child: Column(
        children: [
          Text(
            'CONTACT',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Text(
            'Ready to capture your special moments? Let\'s connect!',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _ContactForm(), // Simple contact form
          const SizedBox(height: 50),
          Text(
            'Find me on social media:',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialIcon(
                icon: FontAwesomeIcons.instagram,
                url:
                    'https://www.facebook.com/share/1PSHTXKw2r/?mibextid=wwXIfr',
              ),
              const SizedBox(width: 30),
              _SocialIcon(
                icon: FontAwesomeIcons.facebook,
                url:
                    'https://www.facebook.com/share/1PSHTXKw2r/?mibextid=wwXIfr',
              ),
              const SizedBox(width: 30),
              _SocialIcon(
                icon: FontAwesomeIcons.linkedin,
                url: 'https://linkedin.com/in/your_profile',
              ),
              const SizedBox(width: 30),
              _SocialIcon(
                icon: Icons.email,
                url: 'mailto:your.email@example.com',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;

  const _SocialIcon({required this.icon, required this.url});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () async {
          if (await canLaunchUrl(Uri.parse(widget.url))) {
            await launchUrl(Uri.parse(widget.url));
          } else {
            // Handle error, e.g., show a SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not launch URL')),
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                _isHovering
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.white10,
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.icon,
            color:
                _isHovering
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}

class _ContactForm extends StatefulWidget {
  const _ContactForm();

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // In a real application, you would send this data to a backend service
      // (e.g., Firebase Functions, a simple email service, etc.)
      // For this example, we'll just print it and show a success message.
      print('Name: ${_nameController.text}');
      print('Email: ${_emailController.text}');
      print('Message: ${_messageController.text}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Message sent! I\'ll get back to you soon.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: Colors.black),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );

      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: Theme.of(context).textTheme.titleMedium,
              filled: true,
              fillColor: Colors.white10,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 2,
                ),
              ),
            ),
            style: Theme.of(context).textTheme.bodyLarge,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: Theme.of(context).textTheme.titleMedium,
              filled: true,
              fillColor: Colors.white10,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 2,
                ),
              ),
            ),
            style: Theme.of(context).textTheme.bodyLarge,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Message',
              labelStyle: Theme.of(context).textTheme.titleMedium,
              filled: true,
              fillColor: Colors.white10,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 2,
                ),
              ),
            ),
            style: Theme.of(context).textTheme.bodyLarge,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your message';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.secondary, // White button
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'SEND MESSAGE',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}
