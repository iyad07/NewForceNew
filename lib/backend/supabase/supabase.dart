import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

export 'database/database.dart';
export 'storage/storage.dart';

const _kSupabaseUrl = 'https://etrgasxxhvyskoekhalf.supabase.co';
const _kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV0cmdhc3h4aHZ5c2tvZWtoYWxmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg3MTQwMDIsImV4cCI6MjAzNDI5MDAwMn0.QpCYCSFwk06mFusW_V93GsqcJ5eAHIpVhi2yrjpHdr0';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  static bool _initialized = false;
  static bool get isInitialized => _initialized;
  
  static SupabaseClient? _supabaseClient;
  static SupabaseClient get client {
    if (_supabaseClient == null) {
      try {
        _supabaseClient = Supabase.instance.client;
      } catch (e) {
        debugPrint('Error getting Supabase client: $e');
        // Return a dummy client that won't crash the app
        throw Exception('Supabase client not initialized');
      }
    }
    return _supabaseClient!;
  }

  static  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      final completer = Completer<void>();
      
      // Set up a timeout to prevent hanging
      Timer(const Duration(seconds: 3), () {
        if (!completer.isCompleted) {
          debugPrint('Supabase initialization timed out, proceeding anyway');
          completer.complete();
          _initialized = true; // Mark as initialized even on timeout
        }
      });
      
      try {
        // Initialize Supabase with optimized settings
        await Supabase.initialize(
          url: _kSupabaseUrl,
          anonKey: _kSupabaseAnonKey,
          debug: false, // Disable debug mode for better performance
        ).timeout(const Duration(seconds: 3));
        
        _supabaseClient = Supabase.instance.client;
        _initialized = true;
        debugPrint('Supabase initialized successfully');
        
        if (!completer.isCompleted) {
          completer.complete();
        }
      } catch (e) {
        debugPrint('Error in Supabase.initialize: $e');
        _initialized = true; // Mark as initialized even on error
        
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
      
      return completer.future;
    } catch (e) {
      debugPrint('Error in Supabase initialization: $e');
      // Continue app flow even if Supabase fails
      _initialized = true; // Mark as initialized even on error
      return;
    }
  }
}
