import 'package:novaed_app/core/widgets/base_scaffold.dart';
import 'package:novaed_app/core/widgets/exit_button.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/app_router.dart';
import '../../../../../core/utils/constants.dart';

class UserProfileBody extends StatefulWidget {
  final int initialIndex;
  const UserProfileBody({super.key, required this.initialIndex});

  @override
  State<UserProfileBody> createState() => _UserProfileBodyState();
}

class _UserProfileBodyState extends State<UserProfileBody> {
  // Mock user data - in a real app, this would come from an API or state management
  final Map<String, dynamic> userData = {
    "username": "user432",
    "firstName": "ابراهيم",
    "secondName": "محمد",
    "lastName": "احمد",
    "gender": "M",
    "email": "ibrahim.ahmed@example.com",
    "notes": "مستخدم نشط يحب متابعة آخر التحديثات والاشتراك في الفعاليات المختلفة.",
    "userPoints": 10
  };

  // For edit mode
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: userData['email']);
    notesController = TextEditingController(text: userData['notes']);
  }

  @override
  void dispose() {
    emailController.dispose();
    notesController.dispose();
    super.dispose();
  }

  // Method to save edited information
  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        userData['email'] = emailController.text;
        userData['notes'] = notesController.text;
        isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Text(
                  'تم حفظ التغييرات بنجاح',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          backgroundColor: correctAnswerColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        ),
      );
    }
  }

  // Toggle edit mode
  void _toggleEditMode(bool edit) {
    setState(() {
      isEditing = edit;
      if (!edit) {
        // Reset controllers when canceling
        emailController.text = userData['email'];
        notesController.text = userData['notes'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return BaseScaffold(
      appBartTitle: 'الملف الشخصي',
      initialIndex: widget.initialIndex,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: backgroundColor,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.03),
                      
                      // User profile card
                      _buildUserProfileCard(),
                      
                      const SizedBox(height: 24),
                      
                      // Edit/Save buttons
                      _buildActionButtons(),
                      
                      const SizedBox(height: 24),
                      
                      // Account information section
                      _buildInfoSection(
                        title: 'معلومات الحساب',
                        icon: Icons.account_circle_outlined,
                        items: [
                          InfoItem(
                            icon: Icons.email_outlined,
                            title: 'البريد الإلكتروني',
                            value: userData['email'],
                            isEditable: true,
                            editWidget: _buildTextField(
                              controller: emailController,
                              hintText: 'البريد الإلكتروني',
                              validator: _emailValidator,
                            ),
                          ),
                          InfoItem(
                            icon: Icons.badge_outlined,
                            title: 'اسم المستخدم',
                            value: userData['username'],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Personal information section
                      _buildInfoSection(
                        title: 'المعلومات الشخصية',
                        icon: Icons.person_outline,
                        items: [
                          InfoItem(
                            icon: Icons.person_outline,
                            title: 'الاسم الكامل',
                            value: '${userData['firstName']} ${userData['secondName']} ${userData['lastName']}',
                          ),
                          InfoItem(
                            icon: Icons.note_outlined,
                            title: 'ملاحظات',
                            value: userData['notes'],
                            isEditable: true,
                            editWidget: _buildTextField(
                              controller: notesController,
                              hintText: 'ملاحظات',
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Logout button
                      const ExitButton(),
                      
                      SizedBox(height: size.height * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // User profile card with avatar and basic info
  Widget _buildUserProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: backgroundBoxesColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.1),
            blurRadius: 25,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with points badge
          Stack(
            children: [
              // Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      mainColor.withOpacity(0.8),
                      progressIndeicatorColor.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: backgroundBoxesColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(),
                        style: const TextStyle(
                          color: mainColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Points badge
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: mainColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        userData['userPoints'].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Full name
          Text(
            '${userData['firstName']} ${userData['secondName']} ${userData['lastName']}',
            style: const TextStyle(
              color: mainTextColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Username
          Text(
            '@${userData['username']}',
            style: const TextStyle(
              color: secondTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Gender badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: userData['gender'] == 'M' 
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.pink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  userData['gender'] == 'M' ? Icons.male : Icons.female,
                  color: userData['gender'] == 'M' ? Colors.blue : Colors.pink,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  userData['gender'] == 'M' ? 'ذكر' : 'أنثى',
                  style: TextStyle(
                    color: userData['gender'] == 'M' ? Colors.blue : Colors.pink,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Action buttons (Edit/Save/Cancel)
  Widget _buildActionButtons() {
    return !isEditing
      ? Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: mainColor.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () => _toggleEditMode(true),
            icon: const Icon(Icons.edit, size: 20),
            label: const Text(
              'تعديل الملف الشخصي',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        )
      : Row(
          children: [
            Expanded(
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: progressIndeicatorColor.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 0,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.save, size: 20),
                  label: const Text(
                    'حفظ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: secondTextColor.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => _toggleEditMode(false),
                  icon: const Icon(Icons.cancel, size: 20),
                  label: const Text(
                    'إلغاء',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondTextColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
  }
  
  // Information section builder
  Widget _buildInfoSection({
    required String title, 
    required IconData icon,
    required List<InfoItem> items
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundBoxesColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: mainColor, size: 20),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: mainTextColor,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Section items
          ...items.asMap().entries.map((entry) {
            int index = entry.key;
            InfoItem item = entry.value;
            return Column(
              children: [
                if (index > 0)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    height: 1,
                    color: mainColor.withOpacity(0.1),
                  ),
                _buildInfoItemWidget(item),
              ],
            );
          }),
        ],
      ),
    );
  }
  
  // Info item widget
  Widget _buildInfoItemWidget(InfoItem item) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: mainColor, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: secondTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (item.isEditable && !isEditing)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.edit,
                          color: mainColor.withOpacity(0.7),
                          size: 14,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                isEditing && item.isEditable
                  ? item.editWidget
                  : Text(
                      item.value,
                      style: const TextStyle(
                        color: mainTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Text field builder for edit mode
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: mainTextColor, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: secondTextColor.withOpacity(0.7)),
        filled: true,
        fillColor: backgroundColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: mainColor.withOpacity(0.2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: mainColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }
  
  // Email validation
  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }
  
  // Logout button
  
  
  
  // Get initials for avatar
  String _getInitials() {
    return userData['firstName'].substring(0, 1) + userData['lastName'].substring(0, 1);
  }
}

// Info item model for better structure
class InfoItem {
  final IconData icon;
  final String title;
  final String value;
  final bool isEditable;
  final Widget editWidget;

  InfoItem({
    required this.icon,
    required this.title,
    required this.value,
    this.isEditable = false,
    this.editWidget = const SizedBox(),
  });
}
