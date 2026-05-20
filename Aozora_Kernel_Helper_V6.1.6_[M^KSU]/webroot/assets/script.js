import { exec, spawn, toast } from './kernelsu.js';

let isProcessing = false;
let bypassStatus = null;

async function checkAllProfiles() {
    const profiles = ['powersave', 'balance', 'gaming', 'gaming2', 'performance', 'cachecleaner'];
    try {
        const cmd = profiles.map(p => `test -f /system/bin/${p} && echo "${p}:EXISTS" || echo "${p}:NOT_FOUND"`).join('; ');
        const { errno, stdout } = await exec(cmd);
        
        if (errno !== 0) return;

        const results = stdout.trim().split('\n');
        results.forEach(line => {
            const [profileName, status] = line.split(':');
            if (status === "NOT_FOUND") {
                const card = document.querySelector(`[data-profile="${profileName}"]`);
                if (card) {
                    const statusEl = card.querySelector('.profile-status');
                    if (statusEl) {
                        statusEl.textContent = "❌ Not found";
                        card.classList.add('disabled');
                    }
                }
            }
        });
    } catch (e) {
        console.log("Check profiles failed:", e);
    }
}

async function executeProfile(profileName, card, statusElement) {
    try {
        const { errno, stdout, stderr } = await exec(profileName);
        if (errno !== 0) {
            throw new Error(stderr || `Command failed with code ${errno}`);
        }

        showOutput(`${stdout}\n\n`);
        highlightProfile(profileName);
        if (statusElement) statusElement.textContent = "Active";

    } catch (error) {
        showOutput(`❌ Error: ${error.message}`);
        if (statusElement) statusElement.textContent = "Failed";

        setTimeout(() => {
            if (statusElement && statusElement.textContent === "Failed") {
                statusElement.textContent = "Tap to activate";
            }
        }, 2000);

    } finally {
        card.classList.remove('loading');
        isProcessing = false;
    }
}

async function switchProfile(event) {
    if (isProcessing) return;

    const card = event.currentTarget;
    const profileName = card.getAttribute('data-profile');

    if (card.classList.contains('disabled')) return;

    isProcessing = true;
    card.classList.add('loading');
    const status = card.querySelector('.profile-status');
    if (status) status.textContent = "⏳ Running...";

    showOutput(`Starting: ${profileName}`);

    setTimeout(() => {
        executeProfile(profileName, card, status);
    }, 10);
}

function showOutput(text) {
    const element = document.getElementById('log');
    if (element) {
        element.textContent = text;
        element.scrollTop = element.scrollHeight;
    }
}

function highlightProfile(profileName) {
    document.querySelectorAll('.profile-card').forEach(card => {
        if (card.classList.contains('disabled')) return;

        if (card.getAttribute('data-profile') === profileName) {
            card.classList.add('active');
        } else {
            card.classList.remove('active');
            const status = card.querySelector('.profile-status');
            if (status && status.textContent === "Active") {
                status.textContent = "Tap to activate";
            }
        }
    });
}

async function checkBypassStatus() {
    try {
        const { errno, stdout } = await exec('cat /sys/class/power_supply/battery/input_suspend');
        if (errno !== 0) throw new Error('Read failed');

        bypassStatus = parseInt(stdout.trim()) === 1;
        updateBypassUI();
    } catch (error) {
        console.log("Bypass check failed:", error);
        const label = document.getElementById('toggleLabel');
        if (label) label.textContent = "Check failed";
    }
}

function updateBypassUI() {
    const track = document.getElementById('toggleTrack');
    const label = document.getElementById('toggleLabel');
    if (!track || !label) return;

    if (bypassStatus === true) {
        track.classList.add('on');
        label.textContent = "ON";
        label.style.color = "#10b981";
    } else if (bypassStatus === false) {
        track.classList.remove('on');
        label.textContent = "OFF";
        label.style.color = "#dc2626";
    }
}

async function toggleBypass() {
    if (bypassStatus === null) return;

    const newValue = bypassStatus ? 0 : 1;
    const track = document.getElementById('toggleTrack');
    const label = document.getElementById('toggleLabel');
    if (!track || !label) return;

    track.classList.toggle('on', newValue === 1);
    label.textContent = "...";
    label.style.color = "#f59e0b";

    const toggleElement = document.querySelector('.bypass-toggle');
    if (toggleElement) toggleElement.style.pointerEvents = 'none';

    try {
        const { errno, stderr } = await exec(`echo ${newValue} > /sys/class/power_supply/battery/input_suspend`);
        if (errno !== 0) throw new Error(stderr || 'Write failed');

        bypassStatus = newValue === 1;
        updateBypassUI();
        showOutput(`Bypass charging: ${newValue === 1 ? 'ON' : 'OFF'}`);
    } catch (error) {
        showOutput(`Error: ${error.message}`);
        bypassStatus = !bypassStatus;
        updateBypassUI();
    } finally {
        if (toggleElement) toggleElement.style.pointerEvents = 'auto';
    }
}

function setupTabs() {
    const navItems = document.querySelectorAll('.nav-item');
    const contents = document.querySelectorAll('.tab-content');

    navItems.forEach(item => {
        item.addEventListener('click', () => {
            const target = item.dataset.tab;

            navItems.forEach(nav => nav.classList.remove('active'));
            item.classList.add('active');

            contents.forEach(content => {
                content.classList.remove('active');
                if (content.id === target + 'Content') {
                    content.classList.add('active');
                }
            });
        });
    });
}

async function updateModuleBadge() {
    const badge = document.querySelector('.hero-badge');
    if (!badge) return;

    const path = '/data/adb/modules/aozora-helper/module.prop';
    try {
        const { errno, stdout } = await exec(`cat ${path} 2>/dev/null`);
        if (errno !== 0 || !stdout) return;

        const props = {};
        stdout.split('\n').forEach(line => {
            const [key, ...val] = line.split('=');
            if (key && val) props[key.trim()] = val.join('=').trim();
        });

        const name = props['name'] || '';
        const version = props['version'] || '';

        if (name && version) badge.textContent = `${name} ${version}`;
        else if (name) badge.textContent = name;
        else if (version) badge.textContent = `Aozora Helper ${version}`;
    } catch (e) {
        console.log("Module badge fetch failed", e);
    }
}

async function detectRootManager() {
    try {
        const { errno, stdout } = await exec('su -v');
        if (errno === 0) {
            const out = stdout.toLowerCase();
            if (out.includes('kernelsu')) return 'KernelSU';
            if (out.includes('magisk')) return 'Magisk';
            if (out.includes('apatch')) return 'APatch';
        }
    } catch (e) {}

    const checks = [
        { name: 'KernelSU', cmd: 'which ksud' },
        { name: 'Magisk', cmd: 'which magisk' },
        { name: 'APatch', cmd: 'which apatch' }
    ];

    for (const { name, cmd } of checks) {
        try {
            const { errno, stdout } = await exec(cmd);
            if (errno === 0 && stdout.trim() !== '') return name;
        } catch (e) {}
    }

    return 'Unknown';
}

async function getRamCapacity() {
    try {
        const { stdout } = await exec('cat /proc/meminfo | grep MemTotal');
        const match = stdout.match(/MemTotal:\s+(\d+)\s+kB/);
        if (match) {
            const memKb = parseInt(match[1], 10);
            const memGb = memKb / (1024 * 1024);
            const totalGb = memGb + 0.5;
            return totalGb.toFixed(1) + ' GB';
        }
    } catch (e) {}
    return '';
}

async function updateHomeInfo() {
    try {
        const [android, kernel, model, soc, os, rootManager, selinux, ram] = await Promise.all([
            exec('getprop ro.build.version.release'),
            exec('cat /proc/version'),
            exec('getprop ro.product.system.model'),
            exec('getprop ro.board.platform'),
            exec('getprop ro.product.build.id'),
            detectRootManager(),
            exec('getenforce'),
            getRamCapacity()
        ]);

        document.getElementById('androidVer').textContent = android.stdout.trim() || 'Unknown';
        document.getElementById('kernelName').textContent = kernel.stdout.trim().split(' ')[2] || 'Unknown';
        document.getElementById('deviceModel').textContent = model.stdout.trim() || 'Unknown';
        document.getElementById('SOC').textContent = soc.stdout.trim() || 'Unknown';
        document.getElementById('OS').textContent = os.stdout.trim() || 'Unknown';
        document.getElementById('rootManager').textContent = rootManager;
        document.getElementById('ramCapacity').textContent = ram;

        const selinuxEl = document.getElementById('selinuxStatus');
        if (selinuxEl) {
            const status = selinux.stdout.trim() || 'Unknown';
            selinuxEl.textContent = status;
            selinuxEl.classList.toggle('text-permissive', status.toLowerCase() === 'permissive');
        }

    } catch (e) {
        console.log('Home info fetch failed', e);
        ['androidVer', 'kernelName', 'deviceModel', 'SOC', 'OS', 'rootManager', 'selinuxStatus', 'ramCapacity'].forEach(id => {
            const el = document.getElementById(id);
            if (el) el.textContent = '';
        });
    }
}

document.addEventListener('DOMContentLoaded', async () => {
    showOutput("Initializing...");

    await Promise.all([
        updateModuleBadge(),
        updateHomeInfo(),
        checkAllProfiles(),
        checkBypassStatus()
    ]).catch(err => {
        console.error('Initialization error:', err);
        showOutput('Some features failed to load.');
    });

    showOutput("Ready. Select profile to execute.");

    document.querySelectorAll('.profile-card').forEach(card => {
        card.addEventListener('click', switchProfile);
    });

    const bypassToggle = document.querySelector('.bypass-toggle');
    if (bypassToggle) {
        bypassToggle.addEventListener('click', toggleBypass);
    }

    setupTabs();
});

document.addEventListener('touchstart', function() {}, {passive: true});