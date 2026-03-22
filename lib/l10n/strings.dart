const Map<String, Map<String, String>> appStrings = {

  // ENGLISH ----
  'en': {
    // ---- landing page START
    'landing_tagline':       'Scan suspicious SMS.\nProtect your family.',
    'get_started':           'Get Started',
    'already_setup':         'I already have a setup',
    // ---- landing page END

    // next button
    'next':                  'Next',
    // save changes button
    'save_changes':          'Save Changes',
    // cancel button
    'cancel':                'Cancel',
    // done button
    'done':                  'Done',
    // safe label
    'safe':                  'Safe',
    // sus label
    'sus':                   'Suspicious',
    // likely scam label
    'likely_scam':           'Likely Scam',
    // return button
    'Return':                'Return',
    // why_flagged label
    'why_flagged':           'WHY IT WAS FLAGGED',
    // notify_fam button
    'notify_fam':            'Notify Family',
    // scan another button
    'scan_another':          'Scan another',
    // result label
    'result':                'Result',

    // ---- on-boarding 1 START
    'onb1_title':            'Paste, Scan, and Learn More',
    'onb1_desc':             'Copy the suspicious TEXT and paste it here. SiyasatPH will tell you if it\'s safe or not—even without internet.',
    // ---- on-boarding 1 END

    // ---- on-boarding 2 START
    'onb2_scan_part1':       'Dear customer, your ',
    'onb2_scan_highlight1':  'BDO',
    'onb2_scan_part2':       ' account will be suspended. ',
    'onb2_scan_highlight2':  'Verify now at:',
    'onb2_scan_part3':       '\n',
    'onb2_scan_highlight3':  'bdo-verify.com',
    'onb2_title':            'Scanning for Red Flags',
    'onb2_desc':             'SiyasatPH looks for scam indicators—fake links, high-pressure language, and fraudulent bank domains.',
    'onb2_fake_link':        'Fake bank link',
    'onb2_fake_link_sub':    'bdo.verify.com ≠ bdo.com.ph',
    'onb2_high_pressure':    'High-pressure language',
    'onb2_high_pressure_sub':'“verify now,” “will be suspended,” “now”',
    'onb2_exp':              'Explanation in Filipino and English',
    'onb2_exp_sub':          'For everyone to understand',
    // ---- on-boarding 2 END

    // ---- on-boarding 3 START
    'onb3_notif_desc':       'Nanay received a potential scam SMS from 09123456789. Review it now.',
    'onb3_notif_call':       'Call',
    'onb3_notif_msg':        'Message',
    'onb3_notif_report':     'Report',
    'onb3_notif_label':      'Family Phone Notification',
    'onb3_title':            'Family Notifications',
    'onb3_desc':             'When a scam is detected, your selected family members will be automatically notified—including the reason and timestamp.',
    'onb3_lola_prim_user':   'Primary User',
    'onb3_md_child':         '(Child)',
    'onb3_md_recipient':     'Alert Recipient',
    // ---- on-boarding 3 END

    // ---- on-boarding 4 START
    'onb4_notif_scam':       'Possible Scam',
    'onb4_notif_desc':       'The message from 09123456789 contains a fake BDO link.',
    'onb4_notif_review':     'Review',
    'onb4_notif_alert':      'Alert Family',
    'onb4_notif_dismiss':    'Dismiss',
    'onb4_title':            'Automatic Alerts',
    'onb4_desc':             'SiyasatPH alerts you immediately when a scam is detected in your SMS—even if the app isn\'t open.',
    'onb4_btn':              'Start setup',
    'onb4_btn_sub':          'Setup takes only seconds.',
    // ---- on-boarding 4 END

    // ---- setup choice START
    'setup_personal_info':  'Personal Information',
    'setup_name':           'Name',
    'setup_skip':           'Skip setup',
    // ---- setup choice END

    // ---- setup bank selection START
    'setup_bank_title':         'What bank do you use?',
    'setup_bank_subtitle':      'Select all that apply.',
    'setup_notif_title':        'Auto-detect scam SMS',
    'setup_notif_sub':          'Automatic Scanning',
    'setup_notif_disclaimer':   'We use rule-based matching for all scans. No data is ever sent outside of your phone.',
    // ---- setup bank selection END

    // ---- notification listener START
    'notif_appbar_title':     'Permission',
    'notif_title':            'Enable SiyasatPH',
    'notif_desc':             'To automatically scan SMS, we need permission to read your notifications.',
    'notif_access_title':     'Notification Access',
    'notif_access_sub':       'To scan SMS notifications',
    'notif_privacy_note':     'We do not read your private messages. Only the notification text is analyzed—and it is never saved.',
    'notif_btn_enable':       'Enable Notification Access',
    'notif_btn_later':        'Do it later',
    'notif_path':             'Settings → Notifications → Notification Access → SiyasatPH',
    // ---- notification listener END

    // ---- history START
    'history_title':          'History',
    // ---- history END 

    // ---- history  expanded START
    'orig_msg':               'ORIGINAL MESSAGE',
    // ---- history expanded END

    // setup START
    'setup_note':            'Update your bank settings or language by tapping Edit on your profile page.',
    // setup END

    // ---- edit profile START
    'edit_prof_title':        'Edit My Profile',
    'edit_section_info':      'Personal Info',
    'edit_name':              'Name',
    'edit_contact':           'Contact Number',
    'edit_banks':             'My Banks',
    'edit_add':               '+ Add',
    // ---- edit profile END

    // ---- edit family member START
    'edit_fam_appbar_title':   'Edit Family Member',
    'edit_fam_section_info':   'Family Member Info',
    // edit_name
    // edit_contact
    'edit_fam_banks':          'Family Member\'s Banks',
    // edit_add
    'edit_fam_remove':         'Remove family member',
    // ---- edit family member END

    // ---- Home START
    'home_title':             'Suspicious message?',
    'home_desc':              'Paste it here to scan. No internet connection required.',
    'home_paste_hint':        'Paste your message here',
    'home_sender':            'Sender\'s number (optional)',
    'home_scan_btn':          'SCAN',
    'home_privacy_note':      'Your message is not saved or transmitted.',
    'home_how_title':         'HOW TO USE?',
    'home_how_1':             '1. Copy the suspicious SMS',
    'home_how_2':             '2. Paste it in the box above',
    'home_how_3':             '3. Tap to Scan',
    'home_how_4':             'See if it\'s safe or not',
    // ---- Home END

    // ---- safe state START
    'safe_verdict':           'Safe',
    'safe_verdict_desc':      'No red flags detected. This message appears to be safe.',
    'safe_analysis_title':    'ANALYSIS',
    'safe_analysis_desc':     'No suspicious links or high-pressure language detected.',
    'safe_analysis_tags':     'No urgency - No fake URLs - No Suspicious Keywords',
    'safe_caution':           'Even if it seems safe, always stay cautious.',
    'safe_scan_another':      'Scan another',
    // ---- safe state END

    // ---- Suspicious state START
    // sus
    'sus_verdict_desc':       'Be careful. Signs of a scam detected. Do not click if you are unsure.',
    'sus_warning_title':      'WARNING',
    'sus_warning_desc':       'Contains "within 24 hours"—a common scammer tactic to create false urgency.',
    'sus_not_sure_title':     'NOT SURE?',
    'sus_not_sure_desc':      'Call your bank directly to verify before taking any action.',
    'sus_caution':            'Even if it seems safe, always stay cautious.',
    // notify_fam
    // scam_another
    // ---- Suspicious state END

    // ---- scam state START
    // likely_scam
    'scam_verdict_desc':      'Do not follow the instructions. This is likely a scam.',
    // why_flagged
    // sus_caution
    'scam_report_ntc':        'Report to NTC',
    'scam_copy_details':      'Copy all details',
    // ---- scam state END

    // ---- report NTC START
    // scam_report_ntc
    'ntc_desc':               'Details are automatically filled. Review before submitting.',
    'scam_sender_num':        'Sender\'s number',
    'ntc_scam_type':          'Type of Scam',
    'scam_content':           'Message Excerpt',
    'ntc_datetime':           'Date and Time',
    'ntc_comment':            'Additional comment (optional)',
    'ntc_comment_hint':       'Enter here...',
    'ntc_upload_id':          'Upload ID',
    // scam_report_ntc
    'ntc_submit_sub':         'Send to NTC via email',
    // ---- report NTC END

    // ---- settings page START
    'settings':              'Settings',
    'section_language':      'LANGUAGE',
    'section_data':          'DATA',
    'section_notifications': 'NOTIFICATIONS',
    'section_about':         'ABOUT',
    'app_language':          'App Language',
    'app_language_sub':      'Select your preferred language',
    'auto_detect':           'Auto-detect SMS',
    'auto_detect_sub':       'Scan SMS automatically',
    'vibrate_scam':          'Vibrate on Scam',
    'vibrate_scam_sub':      'Vibrate when scam is detected',
    'update_patterns':       'Updates Patterns',
    'last_update':           'Last update: March 20, 2026',
    'updated_badge':         'Updated',
    'version':               'Version 1.0.0',
    'privacy_policy':        'Privacy Policy',
    'privacy_policy_sub':    'Read our policy',
    'send_feedback':         'Send Feedback',
    'send_feedback_sub':     'Help us improve the app',
    // ---- settings page END
  },

  // FILIPINO ----
  'fil': {
    // ---- landing page START
    'landing_tagline':       'Scan suspicious SMS.\nProtect your family.',
    'get_started':           'Magsimula',
    'already_setup':         'May setup na ako',
    // ---- landing page END

    // next button
    'next':                  'Susunod',
    // save changes button
    'save_changes':          'I-save ang mga pagbabago',
    // cancel button
    'cancel':                'Kanselahin',
    // done button
    'done':                  'Tapos Na',
    // safe label
    'safe':                  'Ligtas',
    // sus label
    'sus':                   'Kahina-hinala',
    // likely scam label
    'likely_scam':           'Posibleng Scam',
    // return button
    'Return':                'Bumalik',
    // why_flagged label
    'why_flagged':           'BAKIT NA FLAG',
    // notify_fam button
    'notify_fam':            'Sabihan ang Pamilya',
    // scan another button
    'scan_another':          'Suriin ang iba pa',
    // result label
    'result':                'Resulta',


    // ---- on-boarding 1 START
    'onb1_title':     'I-paste, Suriin, at Malaman',
    'onb1_desc':      'Kopyahin ang kahina-hinalang TEXT at i-paste rito. Sasabihin ng SiyasatPH kung ligtas o hindi - kahit walang internet',
    // ---- on-boarding 1 END

    // ---- on-boarding 2 START
    'onb2_scan_part1':       'Mahal na customer, ang iyong ',
    'onb2_scan_highlight1':  'BDO',
    'onb2_scan_part2':       ' account ay maso-suspendo. ',
    'onb2_scan_highlight2':  'I-verify ngayon sa:',
    'onb2_scan_part3':       '\n',
    'onb2_scan_highlight3':  'bdo-verify.com',
    'onb2_title':            'Sisipatin ang mga Red Flag',
    'onb2_desc':             'Hinahanap ng SiyasatPH ang mga palatandaan ng scam -- fake links, mataas ng presyur na pananalita, at mga pekeng domain ng bangko.',
    'onb2_fake_link':        'Fake na link ng bangko',
    'onb2_fake_link_sub':    'bdo.verify.com ≠ bdo.com.ph',
    'onb2_high_pressure':    'Mataas na Presyur na salita',  
    'onb2_high_pressure_sub':'“verify now,” “maso-suspend,” “ngayon”',
    'onb2_exp':              'Paliwanag sa Filipino at English',
    'onb2_exp_sub':          'Para maunawaan ng lahat',
    // ---- on-boarding 2 END

    // ---- on-boarding 3 START
    'onb3_notif_desc':       'May natanggap si Nanay na posibleng scam SMS mula sa  09123456789. Surrin ito ngayon.',
    'onb3_notif_call':       'Tumawag',
    'onb3_notif_msg':        'Mag-text',
    'onb3_notif_report':     'I-report',
    'onb3_notif_label':      'Notification sa telepono ng Pamilya',
    'onb3_title':            'Aabisuhan ang iyong pamilya',
    'onb3_desc':             'Kapag may nakitang scam, awtomatikong maabisuhan ang iyong piling miyembro ng pamilya - kasama ang dahilan at timestamp.',
    'onb3_lola_prim_user':   'Gumagamit ng app',
    'onb3_md_child':         '(Anak)',
    'onb3_md_recipient':     'Tatanggap ng Alert',
    // ---- on-boarding 3 END

    // ---- on-boarding 4 START
    'onb4_notif_scam':       'Posibleng Scam',
    'onb4_notif_desc':       'Ang mensaheng mula sa 09123456789 ay may fake BDO link.',
    'onb4_notif_review':     'Suriin',
    'onb4_notif_alert':      'Sabihan',
    'onb4_notif_dismiss':    'I-dismiss',
    'onb4_title':            'Awtomatikong nag-aalerto',
    'onb4_desc':             'Kapag may nakitang scam sa iyong SMS, mag-aabiso agad ang SisayatPH -- kahit hindi pa nabubuksan ang app.',
    'onb4_btn':              'I-setup ang app',
    'onb4_btn_sub':          'Ilang segundo lang ang setup',
    // ---- on-boarding 4 END

    // ---- setup choice START
    'setup_personal_info':  'Pansariling Impormasyon',
    'setup_name':           'Pangalan',
    'setup_skip':           'Laktawan ang setup',
    // ---- setup choice END

    // ---- setup bank selection START
    'setup_bank_title':         'Anong bangko ang ginagamit mo?',
    'setup_bank_subtitle':      'Piliin lahat ng angkop.',
    'setup_notif_title':        'Awtomatikong pag-detect ng scam SMS',
    'setup_notif_sub':          'Awtomatikong Pag-scan',
    'setup_notif_disclaimer':   'Gumagamit kami ng rule-based matching. Walang data na naipadala sa labas ng iyong telepono.',
    // ---- setup bank selection END

    // ---- notification listener START
    'notif_appbar_title':     'Pahintulot',
    'notif_title':            'Payagan ang SiyasatPH',
    'notif_desc':             'Para awtimatikong suriin ang mga SMS, kailangan ng pahintulot na basahin ang mga notification.',
    'notif_access_title':     'Notification Access',
    'notif_access_sub':       'Para mabasa ang SMS notifications',
    'notif_privacy_note':     'Hindi namin binabasa ang iyong mga mensahe. Ang notification text lamang ang ginagamit — hindi ito nai-save kahit saan.',
    'notif_btn_enable':       'I-enable ang Notification Access',
    'notif_btn_later':        'Gawin mamaya',
    'notif_path':             'Settings → Notifications → Notification Access → SiyasatPH',
    // ---- notification listener END

    // ---- history START
    'history_title':          'History',
    // ---- history END

    // ---- history  expanded START
    'orig_msg':               'ORIHINAL NA MENSAHE',
    // ---- history expanded END

    // setup START
    'setup_note':            'Para baguhin ang iyong mga bangko o language, i-tap ang Edit sa iyong profile.',
    // setup END

    // ---- edit profile START
    'edit_prof_title':        'I-edit ang Aking Profile',
    'edit_section_info':      'Personal na Impormasyon',
    'edit_name':              'Pangalan',
    'edit_contact':           'Numero ng Telepono',
    'edit_banks':             'Aking mga Bangko',
    'edit_add':               '+ Idagdag',
    // ---- edit profile END

    // ---- edit family member START
    'edit_fam_appbar_title':   'Edit Family Member',
    'edit_fam_section_info':   'Impormasyon ng Family Member',
    // edit_name
    // edit_contact
    'edit_fam_banks':          'Mga Bangko ng Family Member',
    // edit_add
    'edit_fam_remove':         'Alisin ang family member',
    // ---- edit family member END

    // ---- Home START
    'home_title':             'May Kahina-hinalang mensahe?',
    'home_desc':              'Ipaste rito para suriin. Walang kailangang internet para rito.',
    'home_paste_hint':        'I-paste ang mensahe rito',
    'home_sender':            'Numero nang nagpadala (opsyonal)',
    'home_scan_btn':          'SURIIN',
    'home_privacy_note':      'Ang mensahe ay hindi nai-save o ipinapadala.',
    'home_how_title':         'PAANO GAMITIN?',
    'home_how_1':             '1. Kopyahin ang kahina-hinalang SMS',
    'home_how_2':             '2. I-paste sa kahon sa itaas',
    'home_how_3':             '3. Pindutin at Suriin',
    'home_how_4':             'Tingnan kung ligtas o hindi',
    // ---- Home END

    // ---- safe state START
    'safe_verdict':           'Ligtas',
    'safe_verdict_desc':      'Walang natuklasang red flag. Ang mensaheng ito ay mukhang ligtas.',
    'safe_analysis_title':    'PAGSUSURI',
    'safe_analysis_desc':     'Walang makitang kahina-hinalang link o mataas na presyur na pananalita.',
    'safe_analysis_tags':     'No urgency - No fake URLs - No Suspicious Keywords',
    'safe_caution':           'Kahit ligtas, ugaliing mag-ingat palagi',
    'safe_scan_another':      'Suriin ang iba pa',
    // ---- safe state END

    // ---- Suspicious state START
    // sus
    'sus_verdict_desc':       'Mag-ingat. May senyales ng scam. Huwag mag-click nang hindi siguardo.',
    'sus_warning_title':      'BABALA',
    'sus_warning_desc':       'Naglalaman ng within 24 hours — karaniwang taktika ng scammer.',
    'sus_not_sure_title':     'HINDI SIGURADO?',
    'sus_not_sure_desc':      'Tawagan ang iyong bangko nang direkta para ma-verify bago gumawa ng aksyon.',
    'sus_caution':            'Kahit ligtas, ugaliing mag-ingat palagi',
    // notify_fam
    // scam_another
    // ---- Suspicious state END

    // ---- scam state START
    // likely_scam
    'scam_verdict_desc':      'Huwag sundin ang mga nakasaad. Ito ay malamang na isang scam.',
    // why_flagged
    // sus_caution
    'scam_report_ntc':        'I-report sa NTC',
    'scam_copy_details':      'Kopyahin ang Detalye',
    // ---- scam state END

    // ---- report NTC START
    // scam_report_ntc
    'ntc_desc':               'Awtimatikong napuno ang mga detalye. I-review bago mag submit.',
    'scam_sender_num':        'Numero ng nagpadala',
    'ntc_scam_type':          'Uri ng Scam',
    'scam_content':           'Bahagi ng Mensahe',
    'ntc_datetime':           'Petsa at Oras',
    'ntc_comment':            'Dagdag na komento (opsyonal)',
    'ntc_comment_hint':       'Ilagay dito...',
    'ntc_upload_id':          'Mag-upload ng ID',
    // scam_report_ntc
    'ntc_submit_sub':         'Send to NTC via email',
    // ---- report NTC END
    
    // ---- settings page START
    'settings':              'Settings',
    'section_language':      'WIKA',
    'section_data':          'DATA',
    'section_notifications': 'NOTIFICATIONS',
    'section_about':         'TUNGKOL',
    'app_language':          'Wika ng App',
    'app_language_sub':      'Piliin ang iyong gustong wika',
    'auto_detect':           'Auto-detect SMS',
    'auto_detect_sub':       'Suriin ang SMS nang awtimatiko',
    'vibrate_scam':          'Vibrate on Scam',
    'vibrate_scam_sub':      'Mag-vibrate kapag may scam',
    'update_patterns':       'I-update ang Patterns',
    'last_update':           'Huling update: March 20, 2026',
    'updated_badge':         'Updated',
    'version':               'Bersyon 1.0.0',
    'privacy_policy':        'Privacy Policy',
    'privacy_policy_sub':    'Basahin ang aming patakaran',
    'send_feedback':         'Magpadala ng Feedback',
    'send_feedback_sub':     'Tulungan kaming mapabuti ang app',
    // ---- settings page END
  },
};