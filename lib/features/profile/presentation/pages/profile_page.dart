import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:majadigi/features/auth/domain/entitiy/user_entity.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_event.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_state.dart';
import 'package:majadigi/features/auth/presentation/widgets/auth_date_picker_field.dart';
import 'package:majadigi/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:majadigi/features/profile/presentation/bloc/profile_event.dart';
import 'package:majadigi/features/profile/presentation/bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSuccess) {
            context.read<AuthBloc>().add(AuthUserUpdated(state.user));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profil berhasil diperbarui')),
            );
          } else if (state is ProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.failure.message)),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 20),
                        _buildRiwayatAktivitas(),
                        const SizedBox(height: 20),
                        _buildInfoSection(context, state.user),
                        const SizedBox(height: 20),
                        _buildAboutSection(context),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, profileState) {
                      if (profileState is ProfileLoading) {
                        return Container(
                          color: Colors.black.withOpacity(0.3),
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              );
            } else if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text("Silakan login terlebih dahulu."));
            }
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: const BoxDecoration(
        color: Color(0xFF004BA0), // Blue header
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            bottom: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatAktivitas() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Riwayat Aktivitas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Lihat Semua >', style: TextStyle(color: Colors.blue)),
              )
            ],
          ),
          const SizedBox(height: 10),
          _buildActivityCard('assets/icons/Hospital Building.svg', 'Tiket RSUD'),
          const SizedBox(height: 10),
          _buildActivityCard('assets/icons/Moon Stars.svg', 'Islamic Center'),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String iconPath, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          SvgPicture.asset(iconPath, width: 24, height: 24, colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.srcIn)),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, UserEntity user) {
    String formattedDate = user.dateOfBirth != null 
        ? DateFormat('dd MMMM yyyy', 'id_ID').format(user.dateOfBirth!) 
        : '-';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Info',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black54),
                onPressed: () => _showEditProfileBottomSheet(context, user),
              )
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                _buildInfoRow('assets/icons/User.svg', 'Nama', user.name),
                const Divider(),
                _buildInfoRow('assets/icons/NIK.svg', 'NIK', user.NIK ?? '-'),
                const Divider(),
                _buildInfoRow('assets/icons/Baby Carriage.svg', 'Tanggal Lahir', formattedDate),
                const Divider(),
                _buildInfoRow('assets/icons/Gender.svg', 'Gender', user.gender ?? '-'),
                const Divider(),
                _buildInfoRow('assets/icons/Address.svg', 'Alamat', user.address ?? '-'),
                const Divider(),
                _buildInfoRow(null, 'Email', user.email, fallbackIcon: Icons.alternate_email),
                const Divider(),
                _buildInfoRow('assets/icons/Password.svg', 'Password', '******************', iconWidth: 26),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String? iconPath, String label, String value, {IconData? fallbackIcon, double? iconWidth}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (iconPath != null)
            SvgPicture.asset(iconPath, width: iconWidth ?? 20, colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.srcIn))
          else if (fallbackIcon != null)
            Icon(fallbackIcon, size: 20, color: Colors.black87),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                _buildAboutRow('assets/icons/Exclamation Circle.svg', 'Laporkan Masalah'),
                const Divider(),
                _buildAboutRow('assets/icons/Phone.svg', 'Kontak Kami'),
                const Divider(),
                _buildAboutRow('assets/icons/Book.svg', 'Privacy Policy'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              context.read<AuthBloc>().add(const SignOutRequested());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  SvgPicture.asset('assets/icons/Logout.svg', width: 24, height: 24, colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn)),
                  const SizedBox(width: 16),
                  const Text('Keluar Akun', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAboutRow(String iconPath, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SvgPicture.asset(iconPath, width: 20, height: 20, colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.srcIn)),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _showEditProfileBottomSheet(BuildContext context, UserEntity user) {
    final nameCtrl = TextEditingController(text: user.name);
    final nikCtrl = TextEditingController(text: user.NIK);
    final emailCtrl = TextEditingController(text: user.email);
    final passwordCtrl = TextEditingController(text: user.password);
    final addressCtrl = TextEditingController(text: user.address);
    DateTime? selectedDate = user.dateOfBirth;
    String? selectedGender = user.gender;
    bool isPasswordVisible = false;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildEditRow(
                      label: 'Nama',
                      iconPath: 'assets/icons/User.svg',
                      child: _buildEditTextField(nameCtrl),
                    ),
                    _buildEditRow(
                      label: 'NIK',
                      iconPath: 'assets/icons/NIK.svg',
                      child: _buildEditTextField(nikCtrl, keyboardType: TextInputType.number),
                    ),
                    _buildEditRow(
                      label: 'Tanggal Lahir',
                      iconPath: 'assets/icons/Baby Carriage.svg',
                      child: _buildEditDateField(context, selectedDate, (date) => setState(() => selectedDate = date)),
                    ),
                    _buildEditRow(
                      label: 'Gender',
                      iconPath: 'assets/icons/Gender.svg',
                      child: _buildGenderRadioGroup(selectedGender, (val) => setState(() => selectedGender = val)),
                    ),
                    _buildEditRow(
                      label: 'Alamat',
                      iconPath: 'assets/icons/Address.svg',
                      child: _buildEditTextField(addressCtrl),
                    ),
                    _buildEditRow(
                      label: 'Email',
                      iconPath: null,
                      fallbackIcon: Icons.alternate_email,
                      child: _buildEditTextField(emailCtrl, keyboardType: TextInputType.emailAddress, readOnly: true),
                    ),
                    _buildEditRow(
                      label: 'Password',
                      iconPath: 'assets/icons/Password.svg',
                      iconWidth: 26,
                      child: _buildEditTextField(
                        passwordCtrl,
                        obscureText: !isPasswordVisible,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          child: Icon(
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004BA0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          context.read<ProfileBloc>().add(UpdateProfileRequested(
                            name: nameCtrl.text,
                            NIK: nikCtrl.text,
                            dateOfBirth: selectedDate ?? DateTime.now(),
                            email: emailCtrl.text,
                            password: passwordCtrl.text,
                            gender: selectedGender,
                            address: addressCtrl.text,
                          ));
                          Navigator.pop(context);
                        },
                        child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildEditRow({
    required String label,
    String? iconPath,
    IconData? fallbackIcon,
    double? iconWidth,
    required Widget child,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              if (iconPath != null)
                SvgPicture.asset(
                  iconPath,
                  width: iconWidth ?? 20,
                  colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.srcIn),
                )
              else if (fallbackIcon != null)
                Icon(fallbackIcon, size: 20, color: Colors.black87),
              const SizedBox(width: 16),
              Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(width: 16),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: child,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
      ],
    );
  }

  Widget _buildEditTextField(
    TextEditingController controller, {
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            readOnly: readOnly,
            textAlign: TextAlign.right,
            keyboardType: keyboardType,
            style: TextStyle(fontSize: 14, color: readOnly ? Colors.grey : Colors.black54),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ),
        if (suffixIcon != null) ...[
          const SizedBox(width: 8),
          suffixIcon,
        ]
      ],
    );
  }

  Widget _buildEditDateField(BuildContext context, DateTime? selectedDate, ValueChanged<DateTime> onDateSelected) {
    String dateText = selectedDate != null 
        ? DateFormat('dd MMMM yyyy', 'id_ID').format(selectedDate) 
        : 'Pilih Tanggal';

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        showCupertinoModalPopup(
          context: context,
          builder: (_) => Container(
            height: 300,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Text('Selesai', style: TextStyle(color: Color(0xFF0066CC), fontWeight: FontWeight.w600)),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SafeArea(
                    top: false,
                    child: CupertinoDatePicker(
                      initialDateTime: selectedDate ?? DateTime.now(),
                      minimumYear: 1900,
                      maximumYear: DateTime.now().year,
                      maximumDate: DateTime.now(),
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: onDateSelected,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Text(
        dateText, 
        style: const TextStyle(fontSize: 14, color: Colors.black54),
      ),
    );
  }

  Widget _buildGenderRadioGroup(String? selectedGender, ValueChanged<String?> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => onChanged('Pria'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(
                value: 'Pria',
                groupValue: selectedGender,
                onChanged: onChanged,
                activeColor: const Color(0xFF004BA0),
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: 4),
              const Text('Pria', style: const TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => onChanged('Wanita'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(
                value: 'Wanita',
                groupValue: selectedGender,
                onChanged: onChanged,
                activeColor: const Color(0xFF004BA0),
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: 4),
              const Text('Wanita', style: const TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}
