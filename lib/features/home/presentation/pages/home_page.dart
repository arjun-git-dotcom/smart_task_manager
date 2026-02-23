import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_task_manager/features/home/presentation/widget/add_task_bottom_sheet.dart';
import 'package:smart_task_manager/features/home/presentation/widget/task_card.dart';
import '../cubit/task_cubit.dart';
import '../cubit/task_state.dart';

class HomePage extends StatefulWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

final Connectivity _connectivity = Connectivity();

StreamSubscription? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    
    
      context.read<TaskCubit>().fetchTasks(userId: widget.userId);
    
    _scrollController.addListener(_onScroll);
    _connectivitySubscription=_connectivity.onConnectivityChanged.listen((result) {
    if (result != ConnectivityResult.none && mounted) {
      context.read<TaskCubit>().fetchTasks(userId: widget.userId);
    }
  });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<TaskCubit>().fetchMoreTasks(userId: widget.userId);
    }
  }

  @override
  void dispose() {
     _connectivitySubscription?.cancel();
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<TaskSort>(
            icon: const Icon(Icons.sort),
            onSelected: (sort) => context.read<TaskCubit>().setSort(sort),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: TaskSort.createdDate,
                child: Text('Created Date'),
              ),
              PopupMenuItem(value: TaskSort.dueDate, child: Text('Due Date')),
              PopupMenuItem(value: TaskSort.priority, child: Text('Priority')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              if (!state.isOffline) return const SizedBox.shrink();
              return Container(
                width: double.infinity,
                color: Colors.red,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'You are offline. Showing cached tasks.',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  context.read<TaskCubit>().setSearch(val);
                });
              },
            ),
          ),

          BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: TaskFilter.values.map((f) {
                  final label = f.name[0].toUpperCase() + f.name.substring(1);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(label),
                      selected: state.filter == f,
                      onSelected: (_) => context.read<TaskCubit>().setFilter(f),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          Expanded(
            child: BlocConsumer<TaskCubit, TaskState>(
              listener: (context, state) {
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                  context.read<TaskCubit>().clearError();
                }
              },
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tasks = state.filteredAndSortedTasks;

                if (tasks.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No tasks found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => context.read<TaskCubit>().fetchTasks(
                    userId: widget.userId,
                  ),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: tasks.length + (state.isPaginating ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == tasks.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return TaskCard(
                        task: tasks[index],
                        userId: widget.userId,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddTaskBottomSheet(userId: widget.userId),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
