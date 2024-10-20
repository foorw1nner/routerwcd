# RouterWCD
Exploiting static directory cache rules

The RouterWCD tool attempts to exploratory static directory cache rules and then proceeds to the second step, where we attempt to find a discrepancy in the dot-segments of the origin server and the cache server.

To do this, we use md5sum to compare the body of the normal response and the modified response (with dot-segments and the static directory with cache rules).

If a discrepancy is found, we begin a probability calculation to identify the percentage chance of being vulnerable to web cache deception.

Tip: RouterWCD can also be an aid tool for manual or semi-automated testing, so providing http headers such as Cookie and Authorization increases your chances.

NOTE: This tool was created based on portswigger's 3rd WCD laboratory: https://portswigger.net/web-security/web-cache-deception#exploiting-static-directory-cache-rules


![image](https://github.com/user-attachments/assets/f852ba62-4163-4a39-830c-8a863d846fc9)

## STEP 1

![image](https://github.com/user-attachments/assets/b10c2f7f-bac9-49d1-9880-0527fbb0b704)

## STEP 2

![image](https://github.com/user-attachments/assets/99367d59-f7ac-4d1c-97c1-4da8571a6901)

Installation
```bash
▶ git clone https://github.com/foorw1nner/routerwcd.git
▶ cd routerwcd
▶ chmod +x routerwcd.sh
```

Usage
```bash
[buffers] | ./routerwcd.sh -host yourtarget.com [flags]
```

Example
```bash
cat crawler.txt | ./hiddenrecon.sh -host host.com -setcookie "Cookie: session=2vv07IdA37Npc1imvN2lQV0ZghMaxSSa" -setauthorization "Authorization: basic cm91dGVyd2Nk" -setmatch "Email|UserID|Token|PHPSESSID"
```
