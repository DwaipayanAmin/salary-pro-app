import express from 'express';

const app = express();
const PORT = 3000;

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', engine: 'Flutter Simulation' });
});

// Serve the interactive Flutter mockup webpage
app.get('/', (req, res) => {
  res.send(`
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Shramik Hub - Native Flutter App Simulation</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Space+Grotesk:wght@500;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    body {
      font-family: 'Inter', sans-serif;
      background-color: #0f172a;
    }
    .space-grotesk {
      font-family: 'Space Grotesk', sans-serif;
    }
    .font-mono {
      font-family: 'JetBrains Mono', monospace;
    }
    /* Custom scrollbar */
    ::-webkit-scrollbar {
      width: 4px;
    }
    ::-webkit-scrollbar-track {
      background: rgba(0, 0, 0, 0.05);
    }
    ::-webkit-scrollbar-thumb {
      background: rgba(156, 163, 175, 0.3);
      border-radius: 4px;
    }
  </style>
</head>
<body class="flex flex-col items-center justify-center min-h-screen p-4 text-slate-100">

  <!-- Desktop Presentation Layout -->
  <div class="flex flex-col lg:flex-row items-center justify-center gap-12 max-w-6xl w-full">
    
    <!-- Info Column -->
    <div class="flex-1 text-center lg:text-left space-y-6">
      <div class="inline-flex items-center gap-2 bg-slate-800/80 border border-slate-700 px-3 py-1 rounded-full text-xs text-amber-400 font-semibold tracking-wider">
        <span class="w-2 h-2 rounded-full bg-amber-400 animate-ping"></span>
        FLUTTER NATIVE APPLICATION CODEBASE
      </div>
      <h1 class="space-grotesk text-4xl lg:text-5xl font-bold tracking-tight text-white leading-tight">
        Shramik Helper <br/>
        <span class="text-amber-400">Offline-First App</span>
      </h1>
      <p class="text-slate-400 text-base lg:text-lg leading-relaxed">
        A premium native Flutter app built with Clean Architecture, StateNotifier-based Riverpod providers, and local offline-first SQLite persistence.
      </p>
      <div class="grid grid-cols-2 gap-4 text-xs font-mono text-slate-400 bg-slate-900/60 p-5 rounded-2xl border border-slate-800">
        <div>📁 /lib/main.dart <span class="text-emerald-400 ml-1">✓ Created</span></div>
        <div>📁 /pubspec.yaml <span class="text-emerald-400 ml-1">✓ Configured</span></div>
        <div>📁 /lib/core/database/ <span class="text-emerald-400 ml-1">✓ SQLite Local DB</span></div>
        <div>📁 /lib/features/ <span class="text-emerald-400 ml-1">✓ Riverpod Models</span></div>
        <div>🤖 Android-first Manifest <span class="text-emerald-400 ml-1">✓ Set up</span></div>
        <div>📱 Material Design 3 <span class="text-emerald-400 ml-1">✓ Responsive</span></div>
      </div>
      
      <div class="flex flex-wrap gap-3 justify-center lg:justify-start">
        <span class="bg-blue-500/10 text-blue-400 px-3 py-1.5 rounded-lg text-xs font-semibold border border-blue-500/20">Flutter 3.x</span>
        <span class="bg-purple-500/10 text-purple-400 px-3 py-1.5 rounded-lg text-xs font-semibold border border-purple-500/20">Riverpod 2.x</span>
        <span class="bg-emerald-500/10 text-emerald-400 px-3 py-1.5 rounded-lg text-xs font-semibold border border-emerald-500/20">SQLite DB</span>
        <span class="bg-amber-500/10 text-amber-400 px-3 py-1.5 rounded-lg text-xs font-semibold border border-amber-500/20">M3 Guidelines</span>
      </div>
    </div>

    <!-- Interactive Phone Mockup Frame -->
    <div class="relative w-[375px] h-[780px] bg-black rounded-[52px] shadow-[0_0_50px_rgba(0,0,0,0.8)] border-[12px] border-slate-800 flex flex-col overflow-hidden select-none">
      
      <!-- Screen notch/island -->
      <div class="absolute top-2 left-1/2 -translate-x-1/2 w-32 h-6 bg-slate-800 rounded-full z-50 flex items-center justify-center">
        <div class="w-3 h-3 rounded-full bg-slate-900 mr-2"></div>
        <div class="w-1.5 h-1.5 rounded-full bg-slate-900"></div>
      </div>

      <!-- Live Interactive Screen Content -->
      <div id="screen" class="flex-1 flex flex-col bg-slate-950 text-slate-100 overflow-hidden relative pt-10 pb-5">
        
        <!-- ================== ONBOARDING SPLASH ================== -->
        <div id="splash-view" class="absolute inset-0 z-40 bg-slate-900 flex flex-col justify-between p-6 pt-12 transition-all duration-500">
          <div class="flex-1 flex flex-col items-center justify-center space-y-6">
            <div class="w-24 h-24 rounded-full bg-slate-800/80 border-2 border-slate-700 flex items-center justify-center shadow-lg shadow-amber-500/10 animate-pulse">
              <svg xmlns="http://www.w3.org/2000/svg" class="w-12 h-12 text-amber-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 11c0 3.517-1.009 6.799-2.753 9.571m-3.44-2.04l.054-.09A13.916 13.916 0 009 11a5 5 0 00-10 0c0 1.017.07 2.019.203 3m-2.118-.114C.13 13.783 0 14.382 0 15c0 2.602.81 4.979 2.185 6.927m14.93-1.012a13.92 13.92 0 01-3.18 3.18m0 0a13.917 13.917 0 01-3.18-3.18m3.18 3.18V13m4-4H8" />
              </svg>
            </div>
            <div class="text-center">
              <h2 class="space-grotesk text-2xl font-bold tracking-wider text-white">SHRAMIK HELPER</h2>
              <p class="text-slate-400 text-sm mt-2">Unified Offline Ledger for Industrial Operators</p>
            </div>
          </div>
          <div class="space-y-4">
            <button onclick="enterApp()" class="w-full bg-white text-slate-950 font-bold py-4 rounded-xl shadow-lg hover:bg-slate-100 transition active:scale-95 flex items-center justify-center gap-2">
              PUNCH-IN NOW
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M14 5l7 7m0 0l-7 7m7-7H3"/></svg>
            </button>
            <div class="flex items-center justify-center gap-2 text-slate-500 text-xs">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-emerald-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
              Offline-First Local Storage Certified
            </div>
          </div>
        </div>

        <!-- ================== APP SHELL CONTAINER ================== -->
        <div class="flex-1 flex flex-col justify-between h-full">
          
          <!-- Top AppBar -->
          <div class="px-4 py-2 flex items-center justify-between border-b border-slate-800 bg-slate-950">
            <div class="flex items-center gap-2">
              <div id="role-avatar-bg" class="p-2 bg-amber-500/20 rounded-full text-amber-400">
                <svg xmlns="http://www.w3.org/2000/svg" id="appbar-icon" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                </svg>
              </div>
              <div>
                <h3 class="font-bold text-xs">Shramik Hub</h3>
                <p id="appbar-role" class="text-[10px] text-slate-400 font-medium">Factory Operator</p>
              </div>
            </div>
            <!-- Sync Notification badge -->
            <button onclick="toggleTheme()" class="p-1.5 hover:bg-slate-800 rounded-lg text-slate-400">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4.5 w-4.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"/></svg>
            </button>
          </div>

          <!-- Tab Content Views Panel -->
          <div class="flex-1 overflow-y-auto px-4 py-3 bg-slate-950">
            
            <!-- 1. HOME VIEW -->
            <div id="view-home" class="space-y-5">
              
              <!-- Role selector scroll -->
              <div class="space-y-1.5">
                <span class="text-[10px] font-bold text-slate-500 tracking-wider">ACTIVE WORK ROLE</span>
                <div class="flex gap-2 overflow-x-auto pb-1" style="scrollbar-width: none;">
                  <button onclick="switchRole('factory')" class="role-chip bg-amber-500 text-slate-950 font-bold text-xs py-1.5 px-3.5 rounded-full flex items-center gap-1.5 whitespace-nowrap transition-all duration-300">
                    Factory Operator
                  </button>
                  <button onclick="switchRole('office')" class="role-chip bg-slate-800 text-slate-400 text-xs py-1.5 px-3.5 rounded-full flex items-center gap-1.5 whitespace-nowrap transition-all duration-300">
                    Office Executive
                  </button>
                  <button onclick="switchRole('warehouse')" class="role-chip bg-slate-800 text-slate-400 text-xs py-1.5 px-3.5 rounded-full flex items-center gap-1.5 whitespace-nowrap transition-all duration-300">
                    Warehouse Handler
                  </button>
                  <button onclick="switchRole('apprentice')" class="role-chip bg-slate-800 text-slate-400 text-xs py-1.5 px-3.5 rounded-full flex items-center gap-1.5 whitespace-nowrap transition-all duration-300">
                    Trade Apprentice
                  </button>
                  <button onclick="switchRole('contract')" class="role-chip bg-slate-800 text-slate-400 text-xs py-1.5 px-3.5 rounded-full flex items-center gap-1.5 whitespace-nowrap transition-all duration-300">
                    Contract Associate
                  </button>
                </div>
              </div>

              <!-- Accumulated Wage Summary Card -->
              <div class="bg-slate-900 border border-slate-800 rounded-2xl p-4 space-y-4">
                <div class="flex items-center justify-between">
                  <span class="text-[10px] font-bold text-slate-500 tracking-wider">ACCUMULATED WAGE SUMMARY</span>
                  <span id="pf-tag" class="text-[10px] bg-green-500/10 text-emerald-400 font-bold px-2 py-0.5 rounded-md border border-green-500/20">PF Eligible</span>
                </div>
                <div class="flex justify-between items-baseline">
                  <h1 id="home-salary" class="space-grotesk text-3xl font-bold text-white">₹18,500</h1>
                  <span id="home-rate" class="text-xs text-slate-400">₹90/hr base</span>
                </div>
                <div class="border-t border-slate-800/80 pt-3 flex justify-between text-xs text-slate-400">
                  <div class="flex items-center gap-1.5">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 text-slate-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    <div>
                      <div class="text-[9px] text-slate-500">Shift Schedule</div>
                      <div id="home-shift" class="font-semibold text-slate-200">Shift A (08:00 - 16:30)</div>
                    </div>
                  </div>
                  <div class="flex items-center gap-1.5">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 text-slate-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                    <div>
                      <div class="text-[9px] text-slate-500">Overtime Rate</div>
                      <div id="home-ot" class="font-semibold text-slate-200">1.5x hourly</div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Quick services grid -->
              <div class="space-y-3">
                <span class="text-[10px] font-bold text-slate-500 tracking-wider">QUICK SERVICES</span>
                <div class="grid grid-cols-2 gap-3">
                  <button onclick="openBottomSheet('advance')" class="bg-gradient-to-br from-amber-500 to-orange-600 rounded-xl p-3 text-left hover:opacity-90 transition flex flex-col justify-between h-24">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    <span class="font-bold text-xs text-white">Salary Advance</span>
                  </button>
                  <button onclick="openBottomSheet('ot')" class="bg-gradient-to-br from-purple-500 to-indigo-600 rounded-xl p-3 text-left hover:opacity-90 transition flex flex-col justify-between h-24">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    <span class="font-bold text-xs text-white">Log Overtime</span>
                  </button>
                  <button onclick="openBottomSheet('payslip')" class="bg-gradient-to-br from-blue-500 to-cyan-600 rounded-xl p-3 text-left hover:opacity-90 transition flex flex-col justify-between h-24">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
                    <span class="font-bold text-xs text-white">View Payslips</span>
                  </button>
                  <button onclick="openBottomSheet('leave')" class="bg-gradient-to-br from-emerald-500 to-teal-600 rounded-xl p-3 text-left hover:opacity-90 transition flex flex-col justify-between h-24">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                    <span class="font-bold text-xs text-white">Apply Leave</span>
                  </button>
                </div>
              </div>

              <!-- Benefits Card -->
              <div class="bg-slate-900 border border-slate-800 rounded-2xl p-4">
                <div class="flex items-center gap-2 mb-3">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-amber-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"/></svg>
                  <span class="font-bold text-xs text-white">Role Benefits & Coverages</span>
                </div>
                <ul id="benefits-list" class="space-y-2.5 text-xs text-slate-300">
                  <li class="flex items-center gap-2"><svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-emerald-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/></svg> Provident Fund (PF)</li>
                  <li class="flex items-center gap-2"><svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-emerald-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/></svg> ESIC Medical Scheme</li>
                </ul>
              </div>

              <!-- Recent activities section -->
              <div class="space-y-3">
                <span class="text-[10px] font-bold text-slate-500 tracking-wider">RECENT SYSTEM LOGS</span>
                <div id="logs-container" class="space-y-2.5">
                  <!-- JS dynamically populates logs here -->
                </div>
              </div>

            </div>

            <!-- 2. TIMECARD VIEW -->
            <div id="view-timecard" class="hidden space-y-6">
              
              <!-- Date and Digital Clock -->
              <div class="text-center py-2">
                <span id="timecard-date" class="text-xs text-slate-500 tracking-wide font-medium">Sunday, 12 July 2026</span>
                <h1 id="timecard-clock" class="space-grotesk text-3xl font-bold mt-1 text-white tracking-wide">11:42:10 AM</h1>
              </div>

              <!-- Biometric Fingerprint Box -->
              <div class="bg-slate-900 border border-slate-800 rounded-3xl p-6 text-center space-y-6 flex flex-col items-center">
                <div class="space-y-1">
                  <span id="shift-status-tag" class="text-[10px] tracking-widest font-bold text-slate-500">NOT CLOCKED IN</span>
                  <h2 id="shift-timer" class="space-grotesk text-2xl font-bold text-slate-500">Hold button to verify ID</h2>
                </div>

                <!-- Touch Scanner Trigger Button -->
                <button onmousedown="startPunchTimer()" onmouseup="cancelPunchTimer()" onmouseleave="cancelPunchTimer()" ontouchstart="startPunchTimer()" ontouchend="cancelPunchTimer()" class="relative group outline-none">
                  <div id="scanner-glow" class="absolute inset-0 bg-amber-500/20 rounded-full blur-xl group-hover:scale-110 transition duration-300"></div>
                  <div id="scanner-button" class="w-28 h-28 rounded-full bg-gradient-to-tr from-amber-500 to-orange-600 flex items-center justify-center border-4 border-slate-950 shadow-2xl relative z-10 active:scale-95 transition-all duration-300">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M12 11c0 3.517-1.009 6.799-2.753 9.571m-3.44-2.04l.054-.09A13.916 13.916 0 009 11a5 5 0 00-10 0c0 1.017.07 2.019.203 3m-2.118-.114C.13 13.783 0 14.382 0 15c0 2.602.81 4.979 2.185 6.927m14.93-1.012a13.92 13.92 0 01-3.18 3.18m0 0a13.917 13.917 0 01-3.18-3.18m3.18 3.18V13m4-4H8" />
                    </svg>
                  </div>
                </button>

                <p id="scanner-hint" class="text-[11px] text-slate-400">Click and hold for 1.2s to swipe shift</p>
              </div>

              <!-- Punch ledger list -->
              <div class="space-y-3">
                <span class="text-[10px] font-bold text-slate-500 tracking-wider">PUNCH CARD LEDGER</span>
                <div id="attendance-ledger" class="space-y-2.5">
                  <!-- Dynamically populated attendance logs -->
                </div>
              </div>

            </div>

            <!-- 3. LEDGER VIEW -->
            <div id="view-ledger" class="hidden space-y-6">
              
              <!-- Large Net Payout Card -->
              <div class="bg-slate-900 border border-slate-800 rounded-3xl p-5 text-center space-y-4">
                <div class="flex items-center justify-between">
                  <span class="text-[10px] font-bold text-slate-500 tracking-wider">NET PAYOUT ACCUMULATION</span>
                  <span class="text-[10px] bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 font-bold px-2 py-0.5 rounded-md">Offline Audited</span>
                </div>
                <h1 id="ledger-net-pay" class="space-grotesk text-4xl font-bold text-white tracking-tight">₹19,250</h1>
                <p id="ledger-sub-text" class="text-xs text-slate-400">Gross: ₹19,850  •  Withholdings: ₹600</p>
              </div>

              <!-- Breakdown analytics cards -->
              <div class="space-y-3">
                <span class="text-[10px] font-bold text-slate-500 tracking-wider">BREAKDOWN ANALYTICS</span>
                <div class="grid grid-cols-2 gap-3">
                  <div class="bg-slate-900 border border-slate-800/80 rounded-2xl p-3.5 space-y-2">
                    <div class="flex justify-between items-center text-slate-500">
                      <span class="text-[9px] font-bold">Basic Wage</span>
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-blue-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    </div>
                    <h3 id="ledger-basic" class="text-base font-bold text-white font-mono">₹18,500</h3>
                  </div>
                  <div class="bg-slate-900 border border-slate-800/80 rounded-2xl p-3.5 space-y-2">
                    <div class="flex justify-between items-center text-slate-500">
                      <span class="text-[9px] font-bold">Overtime Pay</span>
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-purple-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    </div>
                    <h3 id="ledger-ot" class="text-base font-bold text-white font-mono">₹1,350</h3>
                  </div>
                  <div class="bg-slate-900 border border-slate-800/80 rounded-2xl p-3.5 space-y-2">
                    <div class="flex justify-between items-center text-slate-500">
                      <span class="text-[9px] font-bold">Travel & Meal</span>
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-emerald-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M13 16V6a1 1 0 00-1-1H4a1 1 0 00-1 1v10a1 1 0 001 1h8a1 1 0 001-1zM18 16V6a1 1 0 00-1-1h-2a1 1 0 00-1 1v10a1 1 0 001 1h2a1 1 0 001-1z"/></svg>
                    </div>
                    <h3 id="ledger-allow" class="text-base font-bold text-white font-mono">₹600</h3>
                  </div>
                  <div class="bg-slate-900 border border-slate-800/80 rounded-2xl p-3.5 space-y-2">
                    <div class="flex justify-between items-center text-slate-500">
                      <span class="text-[9px] font-bold">Provident Fund</span>
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-rose-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/></svg>
                    </div>
                    <h3 id="ledger-pf" class="text-base font-bold text-rose-400 font-mono">-₹1,200</h3>
                  </div>
                </div>
              </div>

              <!-- Government EPF Card -->
              <div class="bg-slate-900 border border-slate-800 rounded-2xl p-4 space-y-3">
                <div class="flex items-center gap-2 text-amber-400">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
                  <span class="font-bold text-xs">Government EPF Contribution</span>
                </div>
                <p class="text-slate-400 text-[11px] leading-relaxed">
                  Your employer matches your Provident Fund contribution (12%) rupee for rupee. Together with interest, this grows your emergency reserve.
                </p>
                <div class="grid grid-cols-3 gap-2 border-t border-slate-800/80 pt-3 text-center">
                  <div>
                    <div class="text-[9px] text-slate-500">Worker Share</div>
                    <div id="epf-worker" class="font-bold text-xs text-white">₹1,200</div>
                  </div>
                  <div>
                    <div class="text-[9px] text-slate-500">Employer Match</div>
                    <div id="epf-employer" class="font-bold text-xs text-white">₹1,200</div>
                  </div>
                  <div>
                    <div class="text-[9px] text-slate-500">Total Monthly</div>
                    <div id="epf-total" class="font-bold text-xs text-emerald-400">₹2,400</div>
                  </div>
                </div>
              </div>

            </div>

            <!-- 4. PROFILE VIEW -->
            <div id="view-profile" class="hidden space-y-6">
              
              <!-- Profile Avatar Badge -->
              <div class="flex items-center gap-4 py-2">
                <div id="profile-avatar-char" class="w-16 h-16 rounded-full bg-amber-500/20 text-amber-400 flex items-center justify-center text-xl font-bold space-grotesk">
                  R
                </div>
                <div>
                  <h2 id="profile-name" class="font-bold text-lg text-white">Ram Kumar</h2>
                  <p id="profile-pf" class="text-xs text-slate-400 font-medium">Provident Fund ID: PF-8947-AB9</p>
                </div>
              </div>

              <!-- Offline Synchronization Hub Widget -->
              <div class="bg-emerald-500/5 border border-emerald-500/30 rounded-2xl p-4 flex items-center justify-between">
                <div class="flex items-center gap-3">
                  <div class="p-2 bg-emerald-500/10 rounded-xl text-emerald-400">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M3 15a4 4 0 004 4h9a5 5 0 10-.1-9.999 5.002 5.002 0 10-9.78 2.096A4.001 4.001 0 003 15z"/></svg>
                  </div>
                  <div>
                    <h4 class="font-bold text-xs text-emerald-400">OFFLINE ENGINE: ACTIVE</h4>
                    <p class="text-[10px] text-slate-400">Local SQLite database fully synced.</p>
                  </div>
                </div>
                <button onclick="simulateSync()" class="p-2 bg-emerald-500/10 hover:bg-emerald-500/20 active:scale-95 transition rounded-xl text-emerald-400">
                  <svg id="sync-icon" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M4 4v5h.582m15.356 2A8.001 8.001 0 1121.21 19h-1.562"/></svg>
                </button>
              </div>

              <!-- Bank details and Emergency -->
              <div class="space-y-4">
                <div class="flex items-center justify-between">
                  <span class="text-[10px] font-bold text-slate-500 tracking-wider">BANK & CREDENTIALS</span>
                  <button onclick="openProfileEdit()" class="text-slate-400 hover:text-white">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                  </button>
                </div>
                <div class="bg-slate-900 border border-slate-800 rounded-2xl p-4 space-y-3 text-xs">
                  <div class="flex justify-between"><span class="text-slate-500">Full Name</span><span id="profile-card-name" class="font-bold text-white">Ram Kumar</span></div>
                  <div class="border-b border-slate-800/60"></div>
                  <div class="flex justify-between"><span class="text-slate-500">Settlement Bank</span><span id="profile-card-bank" class="font-bold text-white">State Bank of India</span></div>
                  <div class="border-b border-slate-800/60"></div>
                  <div class="flex justify-between"><span class="text-slate-500">Bank Account</span><span id="profile-card-account" class="font-bold text-white">XXXX-XXXX-8821</span></div>
                </div>
              </div>

              <!-- Emergency -->
              <div class="space-y-4">
                <span class="text-[10px] font-bold text-slate-500 tracking-wider">SAFETY & EMERGENCY</span>
                <div class="bg-slate-900 border border-slate-800 rounded-2xl p-4 space-y-3 text-xs">
                  <div class="flex justify-between"><span class="text-slate-500">Assigned Escalation</span><span id="profile-card-contact" class="font-bold text-white">Family Member</span></div>
                  <div class="border-b border-slate-800/60"></div>
                  <div class="flex justify-between"><span class="text-slate-500">Escalation Phone</span><span id="profile-card-phone" class="font-mono font-bold text-white">+91-98765-43210</span></div>
                </div>
              </div>

            </div>

          </div>

          <!-- Bottom Tab Navigation Bar -->
          <div class="border-t border-slate-800 bg-slate-950/95 flex justify-around py-3">
            <button onclick="switchTab('home')" id="tab-home" class="flex flex-col items-center gap-1 text-amber-400">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>
              <span class="text-[9px] font-bold">Home</span>
            </button>
            <button onclick="switchTab('timecard')" id="tab-timecard" class="flex flex-col items-center gap-1 text-slate-500">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 11c0 3.517-1.009 6.799-2.753 9.571m-3.44-2.04l.054-.09A13.916 13.916 0 009 11a5 5 0 00-10 0c0 1.017.07 2.019.203 3m-2.118-.114C.13 13.783 0 14.382 0 15c0 2.602.81 4.979 2.185 6.927m14.93-1.012a13.92 13.92 0 01-3.18 3.18m0 0a13.917 13.917 0 01-3.18-3.18m3.18 3.18V13m4-4H8"/></svg>
              <span class="text-[9px] font-bold">Timecard</span>
            </button>
            <button onclick="switchTab('ledger')" id="tab-ledger" class="flex flex-col items-center gap-1 text-slate-500">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"/></svg>
              <span class="text-[9px] font-bold">Ledger</span>
            </button>
            <button onclick="switchTab('profile')" id="tab-profile" class="flex flex-col items-center gap-1 text-slate-500">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>
              <span class="text-[9px] font-bold">Profile</span>
            </button>
          </div>

        </div>

      </div>

      <!-- ================== MODAL BOTTOM SHEET ================== -->
      <div id="bottom-sheet" class="absolute inset-x-0 bottom-0 bg-slate-900 border-t border-slate-800 rounded-t-[32px] z-50 p-5 space-y-4 transform translate-y-full transition-transform duration-300">
        <div class="flex justify-between items-center">
          <h3 id="sheet-title" class="font-bold text-base text-white">Request Salary Advance</h3>
          <button onclick="closeBottomSheet()" class="text-slate-500 hover:text-white p-1">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>
          </button>
        </div>
        <p id="sheet-desc" class="text-xs text-slate-400 leading-relaxed"></p>
        
        <!-- Interactive form content depending on service -->
        <div id="sheet-form-content"></div>

        <button onclick="submitSheetAction()" class="w-full bg-amber-500 text-slate-950 font-bold py-3.5 rounded-xl hover:bg-amber-400 active:scale-95 transition mt-3 text-xs">
          SUBMIT SECURE REQUEST
        </button>
      </div>

      <!-- ================== PROFILE EDIT MODAL ================== -->
      <div id="profile-dialog" class="absolute inset-0 z-50 bg-black/60 flex items-center justify-center p-4 hidden">
        <div class="bg-slate-900 border border-slate-800 rounded-2xl w-full max-w-[320px] p-5 space-y-4 shadow-2xl">
          <h3 class="font-bold text-base text-white">Update Worker Profile</h3>
          <div class="space-y-3">
            <div>
              <label class="text-[9px] text-slate-500 font-bold">Worker Name</label>
              <input id="edit-name" type="text" class="w-full bg-slate-950 border border-slate-800 rounded-lg p-2 text-xs text-white outline-none focus:border-amber-500" value="Ram Kumar"/>
            </div>
            <div>
              <label class="text-[9px] text-slate-500 font-bold">Settlement Bank</label>
              <input id="edit-bank" type="text" class="w-full bg-slate-950 border border-slate-800 rounded-lg p-2 text-xs text-white outline-none focus:border-amber-500" value="State Bank of India"/>
            </div>
            <div>
              <label class="text-[9px] text-slate-500 font-bold">Bank Account</label>
              <input id="edit-account" type="text" class="w-full bg-slate-950 border border-slate-800 rounded-lg p-2 text-xs text-white outline-none focus:border-amber-500" value="XXXX-XXXX-8821"/>
            </div>
          </div>
          <div class="flex gap-2.5 justify-end">
            <button onclick="closeProfileEdit()" class="text-slate-400 font-bold text-xs py-2 px-3 hover:text-white">CANCEL</button>
            <button onclick="saveProfileEdit()" class="bg-amber-500 text-slate-950 font-bold text-xs py-2 px-4 rounded-lg hover:bg-amber-400 transition">SAVE</button>
          </div>
        </div>
      </div>

    </div>

  </div>

  <!-- Simulated Database Toast Notification -->
  <div id="toast" class="fixed bottom-6 bg-emerald-500 text-slate-950 font-bold text-xs py-3.5 px-5 rounded-xl shadow-2xl flex items-center gap-2 border border-emerald-400/20 transform translate-y-24 opacity-0 transition-all duration-300 z-50">
    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
    <span id="toast-message">Activity saved to local database!</span>
  </div>

  <script>
    // Simulated State Models (reflecting ROLE_CONFIGS & database in Dart codebase)
    const ROLE_CONFIGS = {
      factory: {
        title: 'Factory Operator',
        category: 'Manufacturing & Assembly',
        icon: 'factory',
        baseSalary: 18500,
        hourlyRate: 90,
        shiftType: 'Shift A (08:00 - 16:30)',
        otMultiplier: 1.5,
        pfApplicable: true,
        benefits: ['Provident Fund (PF)', 'ESIC Medical Scheme', 'Night Shift Premium', 'Perfect Attendance Bonus'],
        name: 'Ram Kumar',
        pfNumber: 'PF-8947-AB9',
        bankName: 'State Bank of India',
        bankAccount: 'XXXX-XXXX-8821',
        emergencyContact: 'Family Member',
        emergencyPhone: '+91-98765-43210'
      },
      office: {
        title: 'Office Executive',
        category: 'Administration & HR',
        icon: 'briefcase',
        baseSalary: 26000,
        hourlyRate: 130,
        shiftType: 'General Shift (09:30 - 18:00)',
        otMultiplier: 1.0,
        pfApplicable: true,
        benefits: ['Provident Fund (PF)', 'Gratuity Benefit', '14 Paid Casual Leaves', 'Year-End Performance Bonus'],
        name: 'Anjali Sharma',
        pfNumber: 'PF-4421-CD3',
        bankName: 'HDFC Bank',
        bankAccount: 'XXXX-XXXX-9912',
        emergencyContact: 'Supervisor',
        emergencyPhone: '+91-99887-76655'
      },
      warehouse: {
        title: 'Warehouse Handler',
        category: 'Logistics & Inventory',
        icon: 'truck',
        baseSalary: 16200,
        hourlyRate: 80,
        shiftType: 'Shift B (14:00 - 22:30)',
        otMultiplier: 1.5,
        pfApplicable: true,
        benefits: ['Provident Fund (PF)', 'ESIC Insurance', 'Safety Compliance Bonus', 'Heavy Lifting Allowance'],
        name: 'Sunil Yadav',
        pfNumber: 'PF-5512-EF6',
        bankName: 'Punjab National Bank',
        bankAccount: 'XXXX-XXXX-4423',
        emergencyContact: 'Safety Officer',
        emergencyPhone: '+91-91234-56789'
      },
      apprentice: {
        title: 'Trade Apprentice',
        category: 'Skill Training Program',
        icon: 'school',
        baseSalary: 10500,
        hourlyRate: 50,
        shiftType: 'Apprentice Shift (08:30 - 17:00)',
        otMultiplier: 1.25,
        pfApplicable: false,
        benefits: ['State Skill Certification', 'Dedicated Mentor Support', 'Meal Subsidy Coupon', 'Free Safety Gear Kit'],
        name: 'Rajesh Patra',
        pfNumber: 'N/A (Apprentice)',
        bankName: 'Bank of Baroda',
        bankAccount: 'XXXX-XXXX-1105',
        emergencyContact: 'Mentor Lead',
        emergencyPhone: '+91-88877-66554'
      },
      contract: {
        title: 'Contract Associate',
        category: 'Gig-based Work',
        icon: 'assignment',
        baseSalary: 0,
        hourlyRate: 110,
        shiftType: 'Flexible Hours (On-Demand)',
        otMultiplier: 1.5,
        pfApplicable: false,
        benefits: ['Weekly Direct Settlement', 'Flexible Shift Selection', 'Daily Meal & Travel Allowance', 'Emergency Medical Cover'],
        name: 'Karan Johar',
        pfNumber: 'N/A (Contract)',
        bankName: 'Paytm Payments Bank',
        bankAccount: 'XXXX-XXXX-0099',
        emergencyContact: 'Line Manager',
        emergencyPhone: '+91-77766-55443'
      }
    };

    let activeRole = 'factory';
    let isClockedIn = false;
    let clockInTime = null;
    let elapsedTimer = null;
    let elapsedSeconds = 0;
    
    // SQLite Mock Database lists
    const DB_ACTIVITIES = {
      factory: [
        { id: 1, title: 'Shift A Swipe-In', type: 'attendance', desc: 'Marked Present. Clocked in on-time at Gate-3.', time: '08:02 AM' },
        { id: 2, title: 'Overtime Approved', type: 'ot', desc: 'Supervisor approved 1.5 hours of OT (double-rate).', time: 'Yesterday' }
      ],
      office: [
        { id: 1, title: 'General Shift Swipe-In', type: 'attendance', desc: 'Marked Present. Clocked in via lobby face-scanner.', time: '09:28 AM' }
      ],
      warehouse: [
        { id: 1, title: 'Shift B Swipe-In', type: 'attendance', desc: 'Marked Present. Checked in at Loading Bay-A.', time: '02:05 PM' }
      ],
      apprentice: [
        { id: 1, title: 'Apprentice Shift Swipe-In', type: 'attendance', desc: 'Present. Clocked in on-time at Main Admin Block.', time: '08:31 AM' }
      ],
      contract: [
        { id: 1, title: 'Daily Gig Swipe-In', type: 'attendance', desc: 'Marked active. Verified badge at Assembly Line 4.', time: '09:15 AM' }
      ]
    };

    const DB_ATTENDANCE = {
      factory: [
        { date: 'Friday, 10 July', swipeIn: '08:00 AM', swipeOut: '04:30 PM', hours: '8.5 hrs' },
        { date: 'Thursday, 09 July', swipeIn: '07:58 AM', swipeOut: '05:15 PM', hours: '9.2 hrs' }
      ],
      office: [],
      warehouse: [],
      apprentice: [],
      contract: []
    };

    // Onboarding gate
    function enterApp() {
      document.getElementById('splash-view').classList.add('opacity-0', 'pointer-events-none', 'scale-95');
      setTimeout(() => {
        document.getElementById('splash-view').classList.add('hidden');
      }, 500);
      switchRole('factory');
    }

    // Role Switching handler (mimicking Riverpod activeRoleProvider)
    function switchRole(roleId) {
      activeRole = roleId;
      const config = ROLE_CONFIGS[roleId];

      // Update chips UI
      document.querySelectorAll('.role-chip').forEach(chip => {
        if (chip.innerText.includes(config.title.split(' ')[0])) {
          chip.className = "role-chip bg-amber-500 text-slate-950 font-bold text-xs py-1.5 px-3.5 rounded-full flex items-center gap-1.5 whitespace-nowrap transition-all duration-300";
        } else {
          chip.className = "role-chip bg-slate-800 text-slate-400 text-xs py-1.5 px-3.5 rounded-full flex items-center gap-1.5 whitespace-nowrap transition-all duration-300";
        }
      });

      // Update AppBar
      document.getElementById('appbar-role').innerText = config.title;
      
      // Update UI texts
      document.getElementById('home-salary').innerText = config.baseSalary > 0 ? '₹' + config.baseSalary.toLocaleString('en-IN') : 'Daily Settled';
      document.getElementById('home-rate').innerText = '₹' + config.hourlyRate + '/hr base';
      document.getElementById('home-shift').innerText = config.shiftType;
      document.getElementById('home-ot').innerText = config.otMultiplier + 'x hourly';
      document.getElementById('pf-tag').innerText = config.pfApplicable ? 'PF Eligible' : 'Gig Wage';
      document.getElementById('pf-tag').className = config.pfApplicable 
        ? 'text-[10px] bg-green-500/10 text-emerald-400 font-bold px-2 py-0.5 rounded-md border border-green-500/20' 
        : 'text-[10px] bg-amber-500/10 text-amber-400 font-bold px-2 py-0.5 rounded-md border border-amber-500/20';

      // Update Benefits
      const benefitsUl = document.getElementById('benefits-list');
      benefitsUl.innerHTML = '';
      config.benefits.forEach(b => {
        benefitsUl.innerHTML += \`<li class="flex items-center gap-2"><svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-emerald-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/></svg> \${b}</li>\`;
      });

      // Update Profile Screen Info
      document.getElementById('profile-name').innerText = config.name;
      document.getElementById('profile-pf').innerText = 'Provident Fund ID: ' + config.pfNumber;
      document.getElementById('profile-card-name').innerText = config.name;
      document.getElementById('profile-card-bank').innerText = config.bankName;
      document.getElementById('profile-card-account').innerText = config.bankAccount;
      document.getElementById('profile-card-contact').innerText = config.emergencyContact;
      document.getElementById('profile-card-phone').innerText = config.emergencyPhone;
      document.getElementById('profile-avatar-char').innerText = config.name.substring(0, 1);

      // Update Ledger Screen Info
      const basePay = config.baseSalary > 0 ? config.baseSalary * 0.7 : 8500;
      const otHrs = 6.5;
      const otEarnings = otHrs * config.hourlyRate * config.otMultiplier;
      const allowances = 1200;
      const pfDeducted = config.pfApplicable ? basePay * 0.12 : 0;
      const netPay = basePay + otEarnings + allowances - pfDeducted;

      document.getElementById('ledger-net-pay').innerText = '₹' + netPay.toLocaleString('en-IN', { maximumFractionDigits: 0 });
      document.getElementById('ledger-sub-text').innerText = \`Gross: ₹\${(basePay+otEarnings+allowances).toLocaleString('en-IN', {maximumFractionDigits:0})}  •  Withholdings: ₹\${pfDeducted.toLocaleString('en-IN', {maximumFractionDigits:0})}\`;
      document.getElementById('ledger-basic').innerText = '₹' + basePay.toLocaleString('en-IN', { maximumFractionDigits: 0 });
      document.getElementById('ledger-ot').innerText = '₹' + otEarnings.toLocaleString('en-IN', { maximumFractionDigits: 0 });
      document.getElementById('ledger-allow').innerText = '₹' + allowances.toLocaleString('en-IN', { maximumFractionDigits: 0 });
      document.getElementById('ledger-pf').innerText = pfDeducted > 0 ? '-₹' + pfDeducted.toLocaleString('en-IN', { maximumFractionDigits: 0 }) : 'N/A';
      
      document.getElementById('epf-worker').innerText = pfDeducted > 0 ? '₹' + pfDeducted.toLocaleString('en-IN', { maximumFractionDigits: 0 }) : '₹0';
      document.getElementById('epf-employer').innerText = pfDeducted > 0 ? '₹' + pfDeducted.toLocaleString('en-IN', { maximumFractionDigits: 0 }) : '₹0';
      document.getElementById('epf-total').innerText = pfDeducted > 0 ? '₹' + (pfDeducted * 2).toLocaleString('en-IN', { maximumFractionDigits: 0 }) : '₹0';

      // Load activities
      renderActivities();
      renderAttendanceLedger();
    }

    // Render Recent logs / activities
    function renderActivities() {
      const container = document.getElementById('logs-container');
      container.innerHTML = '';
      const list = DB_ACTIVITIES[activeRole] || [];

      list.forEach(item => {
        let iconColor = 'emerald';
        let iconSvg = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />';
        
        if (item.type === 'ot') {
          iconColor = 'purple';
          iconSvg = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />';
        } else if (item.type === 'general') {
          iconColor = 'blue';
          iconSvg = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />';
        }

        container.innerHTML += `
          <div class="flex gap-3 bg-slate-900/60 p-3 rounded-xl border border-slate-800/60">
            <div class="p-2 bg-\${iconColor}-500/10 rounded-lg text-\${iconColor}-400 h-9 w-9 flex items-center justify-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                \${iconSvg}
              </svg>
            </div>
            <div class="flex-1 min-w-0">
              <div class="flex justify-between items-center">
                <span class="font-bold text-[12px] text-white">\${item.title}</span>
                <span class="text-[9px] text-slate-500 font-mono">\${item.time}</span>
              </div>
              <p class="text-[10px] text-slate-400 mt-0.5 truncate">\${item.desc}</p>
            </div>
          </div>
        `;
      });
    }

    // Render punch card history
    function renderAttendanceLedger() {
      const container = document.getElementById('attendance-ledger');
      container.innerHTML = '';
      const list = DB_ATTENDANCE[activeRole] || [];

      list.forEach(item => {
        container.innerHTML += `
          <div class="bg-slate-900 border border-slate-800 rounded-2xl p-3.5 flex justify-between items-center">
            <div>
              <h4 class="font-bold text-xs text-white">\${item.date}</h4>
              <p class="text-[10px] text-slate-500 mt-1">Swipe-In: \${item.swipeIn}  •  Swipe-Out: \${item.swipeOut}</p>
            </div>
            <span class="bg-blue-500/10 text-blue-400 border border-blue-500/20 font-bold text-[10px] px-2.5 py-1 rounded-lg">\${item.hours}</span>
          </div>
        `;
      });
    }

    // Switch screens
    function switchTab(tabId) {
      document.getElementById('view-home').classList.add('hidden');
      document.getElementById('view-timecard').classList.add('hidden');
      document.getElementById('view-ledger').classList.add('hidden');
      document.getElementById('view-profile').classList.add('hidden');
      
      document.getElementById('view-' + tabId).classList.remove('hidden');

      // Update Navigation styling
      const tabs = ['home', 'timecard', 'ledger', 'profile'];
      tabs.forEach(t => {
        const btn = document.getElementById('tab-' + t);
        if (t === tabId) {
          btn.className = "flex flex-col items-center gap-1 text-amber-400 transition-all duration-200";
        } else {
          btn.className = "flex flex-col items-center gap-1 text-slate-500 hover:text-slate-300 transition-all duration-200";
        }
      });
    }

    // Biometric scanner holding timers
    let holdTimeout = null;
    function startPunchTimer() {
      const btn = document.getElementById('scanner-button');
      const glow = document.getElementById('scanner-glow');
      const hint = document.getElementById('scanner-hint');
      
      btn.classList.add('scale-90', 'rotate-12');
      glow.classList.add('bg-emerald-500/40', 'blur-2xl');
      
      let progress = 0;
      hint.innerText = "Scanning fingerprint...";
      
      holdTimeout = setTimeout(() => {
        btn.classList.remove('scale-90', 'rotate-12');
        glow.classList.remove('bg-emerald-500/40', 'blur-2xl');
        
        triggerShiftToggle();
      }, 1200);
    }

    function cancelPunchTimer() {
      if (holdTimeout) {
        clearTimeout(holdTimeout);
        holdTimeout = null;
      }
      const btn = document.getElementById('scanner-button');
      const glow = document.getElementById('scanner-glow');
      const hint = document.getElementById('scanner-hint');
      
      btn.classList.remove('scale-90', 'rotate-12');
      glow.classList.remove('bg-emerald-500/40', 'blur-2xl');
      hint.innerText = isClockedIn ? "Hold button to Clock-Out" : "Click and hold for 1.2s to swipe shift";
    }

    function triggerShiftToggle() {
      isClockedIn = !isClockedIn;
      
      const tag = document.getElementById('shift-status-tag');
      const timer = document.getElementById('shift-timer');
      const btn = document.getElementById('scanner-button');
      
      if (isClockedIn) {
        tag.innerText = "SHIFT IS RUNNING";
        tag.className = "text-[10px] tracking-widest font-bold text-emerald-400";
        timer.innerText = "00:00:01";
        timer.className = "space-grotesk text-3xl font-bold text-emerald-400 animate-pulse";
        btn.className = "w-28 h-28 rounded-full bg-gradient-to-tr from-emerald-400 to-emerald-700 flex items-center justify-center border-4 border-slate-950 shadow-2xl relative z-10 active:scale-95 transition-all duration-300";
        
        // Start live incrementing ticker
        elapsedSeconds = 0;
        clearInterval(elapsedTimer);
        elapsedTimer = setInterval(() => {
          elapsedSeconds++;
          const h = Math.floor(elapsedSeconds / 3600).toString().padLeft(2, '0');
          const m = Math.floor((elapsedSeconds % 3600) / 60).toString().padLeft(2, '0');
          const s = (elapsedSeconds % 60).toString().padLeft(2, '0');
          timer.innerText = `\${h}:\${m}:\${s}`;
        }, 1000);

        // Add to activities
        DB_ACTIVITIES[activeRole].unshift({
          id: Date.now(),
          title: 'Shift Swipe-In',
          type: 'attendance',
          desc: 'Successfully clocked in on-time via Secure hand biometrics.',
          time: 'Just now'
        });

        showToast('Shift checked in successfully! Recording offline.');
      } else {
        clearInterval(elapsedTimer);
        tag.innerText = "NOT CLOCKED IN";
        tag.className = "text-[10px] tracking-widest font-bold text-slate-500";
        timer.innerText = "Hold button to verify ID";
        timer.className = "space-grotesk text-sm font-semibold text-slate-500";
        btn.className = "w-28 h-28 rounded-full bg-gradient-to-tr from-amber-500 to-orange-600 flex items-center justify-center border-4 border-slate-950 shadow-2xl relative z-10 active:scale-95 transition-all duration-300";
        
        const loggedHrs = (elapsedSeconds / 3600).toFixed(2);
        
        // Add to historical ledger
        DB_ATTENDANCE[activeRole].unshift({
          date: 'Today, 12 July',
          swipeIn: '11:42 AM',
          swipeOut: 'Just now',
          hours: \`\${loggedHrs} hrs\`
        });

        // Add to activities
        DB_ACTIVITIES[activeRole].unshift({
          id: Date.now(),
          title: 'Shift Swipe-Out',
          type: 'attendance',
          desc: \`Completed shift with \${loggedHrs} hours recorded.\`,
          time: 'Just now'
        });

        showToast('Shift recorded in offline ledger!');
      }

      renderActivities();
      renderAttendanceLedger();
    }

    String.prototype.padLeft = function(len, char) {
      let s = this;
      while (s.length < len) s = char + s;
      return s;
    };

    // Bottom Sheets Quick Actions handlers
    function openBottomSheet(serviceId) {
      const sheet = document.getElementById('bottom-sheet');
      const title = document.getElementById('sheet-title');
      const desc = document.getElementById('sheet-desc');
      const formContent = document.getElementById('sheet-form-content');
      
      sheet.classList.remove('translate-y-full');

      if (serviceId === 'advance') {
        title.innerText = "Request Salary Advance";
        desc.innerText = "Need money early? Request an advance up to 50% of your current accrued monthly earnings interest-free. Payouts transfer instantly upon automated swipe verification.";
        formContent.innerHTML = `
          <div class="space-y-2">
            <div class="flex justify-between text-xs text-slate-400 font-bold">
              <span>Advance Amount Requested</span>
              <span class="text-amber-400">₹4,000</span>
            </div>
            <input type="range" class="w-full accent-amber-500" min="500" max="10000" value="4000" />
            <div class="flex justify-between text-[10px] text-slate-500">
              <span>₹500 (Min)</span>
              <span>₹10,000 (Max - 50% Limit)</span>
            </div>
          </div>
        `;
      } else if (serviceId === 'ot') {
        title.innerText = "Log Overtime Hours";
        desc.innerText = "Record extra hours spent outside regular shift limits. Submissions are verified against digital RFID swipe gates automatically.";
        formContent.innerHTML = `
          <div class="flex gap-2.5 justify-center py-2">
            <button class="bg-slate-800 text-slate-400 text-xs py-1.5 px-4 rounded-xl border border-slate-700/50">1.0 Hr</button>
            <button class="bg-amber-500 text-slate-950 font-bold text-xs py-1.5 px-4 rounded-xl">2.0 Hrs</button>
            <button class="bg-slate-800 text-slate-400 text-xs py-1.5 px-4 rounded-xl border border-slate-700/50">3.0 Hrs</button>
          </div>
        `;
      } else if (serviceId === 'payslip') {
        title.innerText = "View Interactive Payslips";
        desc.innerText = "View, download, or share digitally signed PDF payslips complete with tax breakdowns, PF, and OT bonuses.";
        formContent.innerHTML = `
          <div class="space-y-2">
            <div class="flex justify-between bg-slate-950 p-3 rounded-xl border border-slate-800 text-xs items-center">
              <span>June_2026_Payslip.pdf</span>
              <span class="text-emerald-400 font-bold">Ready</span>
            </div>
            <div class="flex justify-between bg-slate-950 p-3 rounded-xl border border-slate-800 text-xs items-center">
              <span>May_2026_Payslip.pdf</span>
              <span class="text-emerald-400 font-bold">Ready</span>
            </div>
          </div>
        `;
      } else if (serviceId === 'leave') {
        title.innerText = "Apply Casual Leave / Time-Off";
        desc.innerText = "Submit requests for sick leave, casual leave, or unpaid personal days off. Checks active balance dynamically before processing.";
        formContent.innerHTML = `
          <textarea placeholder="Enter emergency cause, sickness or family travel info" class="w-full bg-slate-950 border border-slate-800 text-xs rounded-xl p-3 text-white outline-none focus:border-amber-500 h-20 resize-none"></textarea>
        `;
      }
    }

    function closeBottomSheet() {
      document.getElementById('bottom-sheet').classList.add('translate-y-full');
    }

    function submitSheetAction() {
      closeBottomSheet();
      
      DB_ACTIVITIES[activeRole].unshift({
        id: Date.now(),
        title: 'Form Requested',
        type: 'general',
        desc: 'Request processed and logged in local ledger database.',
        time: 'Just now'
      });
      renderActivities();

      showToast('Form logged successfully in local SQLite ledger!');
    }

    // Profile updates dialogue
    function openProfileEdit() {
      document.getElementById('profile-dialog').classList.remove('hidden');
    }
    
    function closeProfileEdit() {
      document.getElementById('profile-dialog').classList.add('hidden');
    }

    function saveProfileEdit() {
      const name = document.getElementById('edit-name').value;
      const bank = document.getElementById('edit-bank').value;
      const acc = document.getElementById('edit-account').value;

      ROLE_CONFIGS[activeRole].name = name;
      ROLE_CONFIGS[activeRole].bankName = bank;
      ROLE_CONFIGS[activeRole].bankAccount = acc;

      switchRole(activeRole);
      closeProfileEdit();
      showToast('Profile credentials saved offline!');
    }

    // Database Sync Simulator
    function simulateSync() {
      const icon = document.getElementById('sync-icon');
      icon.classList.add('animate-spin');
      
      showToast('Compiling secure local SQLite checksums...');

      setTimeout(() => {
        icon.classList.remove('animate-spin');
        
        DB_ACTIVITIES[activeRole].unshift({
          id: Date.now(),
          title: 'Database Cloud Sync',
          type: 'general',
          desc: 'Secure biometric shifts & earnings synced to industrial server successfully.',
          time: 'Just now'
        });
        renderActivities();

        showToast('SQLite shifts synchronized with cloud server!');
      }, 1500);
    }

    // Toast UI helpers
    function showToast(message) {
      const toast = document.getElementById('toast');
      document.getElementById('toast-message').innerText = message;
      
      toast.classList.remove('translate-y-24', 'opacity-0');
      
      setTimeout(() => {
        toast.classList.add('translate-y-24', 'opacity-0');
      }, 3000);
    }

    // Default initialization
    window.onload = () => {
      // Intentionally starts at onboarding splash screen first
    };
  </script>
</body>
</html>
  `);
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Express dev server running at http://0.0.0.0:${PORT}`);
});
