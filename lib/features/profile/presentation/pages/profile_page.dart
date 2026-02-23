import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_task_manager/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:smart_task_manager/features/profile/presentation/widgets/info_card.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfilePage extends StatelessWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});



  void _showEditNameDialog(BuildContext context, profile) {
  final nameController = TextEditingController(text: profile.name);
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Edit Name'),
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(
          labelText: 'Name',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final updatedProfile = profile.copyWith(name: nameController.text.trim());
            context.read<ProfileCubit>().updateProfile(updatedProfile);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(context.read())..fetchUserProfile(uid),
      child: Scaffold(
        appBar: AppBar(
  title: const Text('Profile'),
  automaticallyImplyLeading: false,
actions: [
  Builder(
    builder: (context) => IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Logout'),
              ),
            ],
          ),
        );

        if (confirm == true && context.mounted) {
          await context.read<AuthCubit>().logoutUser();
          Navigator.pushReplacementNamed(context, '/');
        }
      },
    ),
  ),
],
),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.errorMessage!, style: const TextStyle(color: Colors.red)),
                  ],
                ),
              );
            }

            final profile = state.profile;
            if (profile == null) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No profile found', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            profile.email.isNotEmpty
                                ? profile.email[0].toUpperCase()
                                : '?',
                            style: const TextStyle(fontSize: 40, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
  profile.name.isNotEmpty ? profile.name : profile.email.split('@')[0],
  style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
),

Builder(
  builder:(context)=> TextButton.icon(
    icon: const Icon(Icons.edit),
    label: const Text('Edit Name'),
    onPressed: () => _showEditNameDialog(context, profile),
  ),
),
                        const SizedBox(height: 4),
                        Text(
                          profile.email,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                        
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        InfoCard(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: profile.email,
                        ),
                        const SizedBox(height: 12),
                        InfoCard(
                          icon: Icons.calendar_today_outlined,
                          label: 'Member Since',
                          value:
                              '${profile.createdAt.day}/${profile.createdAt.month}/${profile.createdAt.year}',
                        ),
                        const SizedBox(height: 12),

                      
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    profile.isDarkMode
                                        ? Icons.dark_mode
                                        : Icons.light_mode,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'Dark Mode',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                Switch(
                                  value: profile.isDarkMode,
                                  onChanged: (val) {
                                    final updatedProfile =
                                        profile.copyWith(isDarkMode: val);
                                    context
                                        .read<ProfileCubit>()
                                        .updateProfile(updatedProfile);
                                    context
                                        .read<AuthCubit>()
                                        .updateUserProfile(updatedProfile);
                                  },
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
            );
          },
        ),
      ),
    );
  }
}
