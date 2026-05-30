//
//  SupabaseConfiguration.swift
//  CobraSthenics
//
//  Created by Jordan Bhar on 2026-05-30.
//

import Foundation
import Supabase

let supabase = SupabaseClient(
  supabaseURL: URL(string: AppEnvironment.supabaseURL)!,
  supabaseKey: AppEnvironment.supabaseAnonKey
)
