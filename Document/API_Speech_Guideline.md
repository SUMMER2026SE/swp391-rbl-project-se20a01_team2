# TÀI LIỆU HƯỚNG DẪN TÍCH HỢP API SPEECH-TO-TEXT VÀ CHẤM ĐIỂM SPEAKING
**Người lập:** Thanh Phong
**Dự án:** IELTSFlow

Tài liệu này hướng dẫn các thành viên trong dự án (đặc biệt là Frontend Team) cách kết nối và sử dụng API xử lý giọng nói do Backend cung cấp. API này sử dụng dịch vụ Azure AI Speech để giải quyết 2 bài toán cốt lõi:
1. **Speech-to-Text (STT)**: Chuyển đổi giọng nói thành văn bản.
2. **Pronunciation Assessment**: Chấm điểm phát âm dựa trên 4 tiêu chí (Fluency, Accuracy, Completeness, Prosody).

---

## 1. THÔNG TIN ENDPOINT CHÍNH

- **URL:** `POST /api/speech/assess`
- **Content-Type:** `multipart/form-data`

API này xử lý gộp cả 2 trường hợp:
- **Trường hợp A (Có kịch bản - Read Aloud)**: Bạn gửi lên file ghi âm + Đoạn text thí sinh cần đọc. API sẽ trả về STT và Bảng điểm Pronunciation.
- **Trường hợp B (Nói tự do - Unscripted)**: Bạn chỉ gửi lên file ghi âm. API chỉ trả về văn bản dịch ra (STT).

---

## 2. YÊU CẦU ĐỊNH DẠNG ÂM THANH (QUAN TRỌNG)

> [!WARNING]
> Azure SDK backend yêu cầu định dạng audio nghiêm ngặt. Nếu gửi sai, API sẽ báo lỗi 500 hoặc `NoMatch`.
> **Định dạng bắt buộc:** `WAV`, Sample Rate `16000Hz (16kHz)`, `16-bit`, `Mono (1 kênh)`.

**Gợi ý cho Frontend (JavaScript):**
Bởi vì `MediaRecorder` mặc định của trình duyệt web thường tạo ra `.webm` (Chrome) hoặc `.ogg` (Firefox), bạn không thể gửi trực tiếp file này lên Server.
Frontend cần dùng các thư viện như `recordrtc` hoặc `extendable-media-recorder` kết hợp `wav-encoder` để thu âm và nén đúng chuẩn WAV trước khi gửi request.

---

## 3. CÁCH GỌI API (REQUEST)

Sử dụng `FormData` trong JavaScript để đóng gói dữ liệu:

### Mẫu Code Frontend (Fetch API)

```javascript
// Giả sử audioBlob là file WAV 16kHz lấy từ bộ ghi âm của Frontend
const formData = new FormData();
formData.append("audioFile", audioBlob, "speaking_record.wav");

// NẾU CÓ ĐỀ BÀI ĐỌC CHUẨN (Ví dụ: Thí sinh đang làm dạng bài Read Aloud)
// Bạn cần gửi thêm câu chữ mà thí sinh phải đọc để AI đối chiếu
formData.append("referenceText", "This is the text the candidate is supposed to read."); 

// NẾU THÍ SINH NÓI TỰ DO (Ví dụ: Speaking Part 2)
// KHÔNG truyền biến referenceText, hệ thống sẽ tự động hiểu là chỉ cần dịch STT.

fetch('http://localhost:8080/IELTSFLOW/api/speech/assess', {
    method: 'POST',
    body: formData
})
.then(response => response.json())
.then(data => console.log(data))
.catch(error => console.error("Lỗi:", error));
```

---

## 4. CẤU TRÚC PHẢN HỒI (RESPONSE JSON)

### Trường hợp 1: Chấm điểm phát âm thành công (Có gửi `referenceText`)
Hệ thống sẽ trả về JSON chứa đầy đủ các điểm (thang 100) và chuỗi `detailedJson` để Frontend có thể hiển thị đổi màu các từ đọc sai.

```json
{
  "success": true,
  "data": {
    "success": true,
    "accuracyScore": 85.0,
    "fluencyScore": 79.0,
    "completenessScore": 100.0,
    "prosodyScore": 81.0,
    "pronunciationScore": 83.0,
    "recognizedText": "This is the text the candidate is supposed to read.",
    "errorMessage": null,
    "detailedJson": {
        // ... (Cấu trúc JSON chi tiết từ Azure, chứa mảng Words và ErrorType: Omission, Insertion, Mispronunciation)
    }
  }
}
```

### Trường hợp 2: STT tự do thành công (Không gửi `referenceText`)

```json
{
  "success": true,
  "data": {
    "transcript": "Well in my opinion learning English is very important because..."
  }
}
```

### Trường hợp 3: Có lỗi xảy ra

```json
{
  "success": false,
  "error": "Vui lòng đính kèm file âm thanh (audioFile)."
}
```

---

## 5. LƯU Ý CHO BACKEND TEAM (Ghi chú nội bộ)

Khi API chạy thành công ở Trường hợp 1 (chấm điểm), Backend (cụ thể là class `SpeechAssessmentServlet.java`) sẽ tự động gọi qua tầng `SubmissionDetailsDAO.java`.
Hàm `updateSpeakingEvaluation(detailId, transcript, azureScore)` sẽ đảm nhận việc:
1. Convert con số điểm `pronunciationScore` (ví dụ 83.0) sang chuẩn IELTS Band (từ 0 đến 9.0).
2. Lưu kết quả Band điểm vào cột `Score` và lưu chữ vào cột `CandidateTranscript` trên Table `SubmissionDetails` của cơ sở dữ liệu.

Nếu mọi người gặp lỗi khi test nghiệm thu tính năng này trên máy Local, hãy đảm bảo các bạn đã kéo file `.env` mới nhất hoặc thêm 2 biến `SPEECH_KEY` và `SPEECH_REGION` (được anh Phong cung cấp nội bộ) vào file `.env` trong máy của các bạn.

## 6. EXAMPLE RESPONSE

```
{
    "data": {
        "success": true,
        "accuracyScore": 94,
        "fluencyScore": 98,
        "completenessScore": 100,
        "prosodyScore": 78.8,
        "pronunciationScore": 89.9,
        "recognizedText": "Go from New York to Los Angeles.",
        "detailedJson": {
            "Id": "7efb04ac85344b8caa3f3905b821b677",
            "RecognitionStatus": "Success",
            "Offset": 7300000,
            "Duration": 34900000,
            "Channel": 0,
            "DisplayText": "Go from New York to Los Angeles.",
            "SNR": 15.567844,
            "NBest": [
                {
                    "Confidence": 0.9645948,
                    "Lexical": "go from new york to los angeles",
                    "ITN": "go from new york to los angeles",
                    "MaskedITN": "go from new york to los angeles",
                    "Display": "Go from New York to Los Angeles.",
                    "PronunciationAssessment": {
                        "AccuracyScore": 94,
                        "FluencyScore": 98,
                        "ProsodyScore": 78.8,
                        "CompletenessScore": 100,
                        "PronScore": 89.9
                    },
                    "Words": [
                        {
                            "Word": "go",
                            "Offset": 7300000,
                            "Duration": 4700000,
                            "PronunciationAssessment": {
                                "AccuracyScore": 94,
                                "ErrorType": "None",
                                "Feedback": {
                                    "Prosody": {
                                        "Break": {
                                            "ErrorTypes": [
                                                "None"
                                            ],
                                            "BreakLength": 0
                                        },
                                        "Intonation": {
                                            "ErrorTypes": [
                                                "Monotone"
                                            ],
                                            "Monotone": {
                                                "SyllablePitchDeltaConfidence": 0.19449864
                                            }
                                        }
                                    }
                                }
                            },
                            "Syllables": [
                                {
                                    "Syllable": "gow",
                                    "Grapheme": "go",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 72
                                    },
                                    "Offset": 7300000,
                                    "Duration": 4700000
                                }
                            ],
                            "Phonemes": [
                                {
                                    "Phoneme": "g",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 64
                                    },
                                    "Offset": 7300000,
                                    "Duration": 2300000
                                },
                                {
                                    "Phoneme": "ow",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 79
                                    },
                                    "Offset": 9700000,
                                    "Duration": 2300000
                                }
                            ]
                        },
                        {
                            "Word": "from",
                            "Offset": 12100000,
                            "Duration": 5900000,
                            "PronunciationAssessment": {
                                "AccuracyScore": 94,
                                "ErrorType": "None",
                                "Feedback": {
                                    "Prosody": {
                                        "Break": {
                                            "ErrorTypes": [
                                                "None"
                                            ],
                                            "UnexpectedBreak": {
                                                "Confidence": 2.6239068e-8
                                            },
                                            "MissingBreak": {
                                                "Confidence": 1
                                            },
                                            "BreakLength": 0
                                        },
                                        "Intonation": {
                                            "ErrorTypes": [
                                                "Monotone"
                                            ],
                                            "Monotone": {
                                                "SyllablePitchDeltaConfidence": 0.19449864
                                            }
                                        }
                                    }
                                }
                            },
                            "Syllables": [
                                {
                                    "Syllable": "fraam",
                                    "Grapheme": "from",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 81
                                    },
                                    "Offset": 12100000,
                                    "Duration": 5900000
                                }
                            ],
                            "Phonemes": [
                                {
                                    "Phoneme": "f",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 65
                                    },
                                    "Offset": 12100000,
                                    "Duration": 2300000
                                },
                                {
                                    "Phoneme": "r",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 100
                                    },
                                    "Offset": 14500000,
                                    "Duration": 900000
                                },
                                {
                                    "Phoneme": "aa",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 100
                                    },
                                    "Offset": 15500000,
                                    "Duration": 1500000
                                },
                                {
                                    "Phoneme": "m",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 69
                                    },
                                    "Offset": 17100000,
                                    "Duration": 900000
                                }
                            ]
                        },
                        {
                            "Word": "new",
                            "Offset": 18300000,
                            "Duration": 3000000,
                            "PronunciationAssessment": {
                                "AccuracyScore": 91,
                                "ErrorType": "None",
                                "Feedback": {
                                    "Prosody": {
                                        "Break": {
                                            "ErrorTypes": [
                                                "None"
                                            ],
                                            "UnexpectedBreak": {
                                                "Confidence": 0.05247816
                                            },
                                            "MissingBreak": {
                                                "Confidence": 0.9737609
                                            },
                                            "BreakLength": 200000
                                        },
                                        "Intonation": {
                                            "ErrorTypes": [
                                                "Monotone"
                                            ],
                                            "Monotone": {
                                                "SyllablePitchDeltaConfidence": 0.19449864
                                            }
                                        }
                                    }
                                }
                            },
                            "Syllables": [
                                {
                                    "Syllable": "nuw",
                                    "Grapheme": "new",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 64
                                    },
                                    "Offset": 18300000,
                                    "Duration": 3000000
                                }
                            ],
                            "Phonemes": [
                                {
                                    "Phoneme": "n",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 72
                                    },
                                    "Offset": 18300000,
                                    "Duration": 1500000
                                },
                                {
                                    "Phoneme": "uw",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 55
                                    },
                                    "Offset": 19900000,
                                    "Duration": 1400000
                                }
                            ]
                        },
                        {
                            "Word": "york",
                            "Offset": 21400000,
                            "Duration": 5400000,
                            "PronunciationAssessment": {
                                "AccuracyScore": 97,
                                "ErrorType": "None",
                                "Feedback": {
                                    "Prosody": {
                                        "Break": {
                                            "ErrorTypes": [
                                                "None"
                                            ],
                                            "UnexpectedBreak": {
                                                "Confidence": 2.6239068e-8
                                            },
                                            "MissingBreak": {
                                                "Confidence": 1
                                            },
                                            "BreakLength": 0
                                        },
                                        "Intonation": {
                                            "ErrorTypes": [
                                                "Monotone"
                                            ],
                                            "Monotone": {
                                                "SyllablePitchDeltaConfidence": 0.19449864
                                            }
                                        }
                                    }
                                }
                            },
                            "Syllables": [
                                {
                                    "Syllable": "yaork",
                                    "Grapheme": "york",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 78
                                    },
                                    "Offset": 21400000,
                                    "Duration": 5400000
                                }
                            ],
                            "Phonemes": [
                                {
                                    "Phoneme": "y",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 100
                                    },
                                    "Offset": 21400000,
                                    "Duration": 1200000
                                },
                                {
                                    "Phoneme": "ao",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 100
                                    },
                                    "Offset": 22700000,
                                    "Duration": 700000
                                },
                                {
                                    "Phoneme": "r",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 100
                                    },
                                    "Offset": 23500000,
                                    "Duration": 900000
                                },
                                {
                                    "Phoneme": "k",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 49
                                    },
                                    "Offset": 24500000,
                                    "Duration": 2300000
                                }
                            ]
                        },
                        {
                            "Word": "to",
                            "Offset": 26900000,
                            "Duration": 4000000,
                            "PronunciationAssessment": {
                                "AccuracyScore": 94,
                                "ErrorType": "None",
                                "Feedback": {
                                    "Prosody": {
                                        "Break": {
                                            "ErrorTypes": [
                                                "None"
                                            ],
                                            "UnexpectedBreak": {
                                                "Confidence": 2.6239068e-8
                                            },
                                            "MissingBreak": {
                                                "Confidence": 1
                                            },
                                            "BreakLength": 0
                                        },
                                        "Intonation": {
                                            "ErrorTypes": [
                                                "Monotone"
                                            ],
                                            "Monotone": {
                                                "SyllablePitchDeltaConfidence": 0.19449864
                                            }
                                        }
                                    }
                                }
                            },
                            "Syllables": [
                                {
                                    "Syllable": "tuw",
                                    "Grapheme": "to",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 78
                                    },
                                    "Offset": 26900000,
                                    "Duration": 4000000
                                }
                            ],
                            "Phonemes": [
                                {
                                    "Phoneme": "t",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 77
                                    },
                                    "Offset": 26900000,
                                    "Duration": 900000
                                },
                                {
                                    "Phoneme": "uw",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 78
                                    },
                                    "Offset": 27900000,
                                    "Duration": 3000000
                                }
                            ]
                        },
                        {
                            "Word": "los",
                            "Offset": 31200000,
                            "Duration": 3400000,
                            "PronunciationAssessment": {
                                "AccuracyScore": 97,
                                "ErrorType": "None",
                                "Feedback": {
                                    "Prosody": {
                                        "Break": {
                                            "ErrorTypes": [
                                                "None"
                                            ],
                                            "UnexpectedBreak": {
                                                "Confidence": 0.05247816
                                            },
                                            "MissingBreak": {
                                                "Confidence": 0.9737609
                                            },
                                            "BreakLength": 200000
                                        },
                                        "Intonation": {
                                            "ErrorTypes": [
                                                "Monotone"
                                            ],
                                            "Monotone": {
                                                "SyllablePitchDeltaConfidence": 0.19449864
                                            }
                                        }
                                    }
                                }
                            },
                            "Syllables": [
                                {
                                    "Syllable": "laos",
                                    "Grapheme": "los",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 86
                                    },
                                    "Offset": 31200000,
                                    "Duration": 3400000
                                }
                            ],
                            "Phonemes": [
                                {
                                    "Phoneme": "l",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 100
                                    },
                                    "Offset": 31200000,
                                    "Duration": 1200000
                                },
                                {
                                    "Phoneme": "ao",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 100
                                    },
                                    "Offset": 32500000,
                                    "Duration": 1100000
                                },
                                {
                                    "Phoneme": "s",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 51
                                    },
                                    "Offset": 33700000,
                                    "Duration": 900000
                                }
                            ]
                        },
                        {
                            "Word": "angeles",
                            "Offset": 35000000,
                            "Duration": 7200000,
                            "PronunciationAssessment": {
                                "AccuracyScore": 91,
                                "ErrorType": "None",
                                "Feedback": {
                                    "Prosody": {
                                        "Break": {
                                            "ErrorTypes": [
                                                "None"
                                            ],
                                            "UnexpectedBreak": {
                                                "Confidence": 0.078717224
                                            },
                                            "MissingBreak": {
                                                "Confidence": 0.9606414
                                            },
                                            "BreakLength": 300000
                                        },
                                        "Intonation": {
                                            "ErrorTypes": [
                                                "Monotone"
                                            ],
                                            "Monotone": {
                                                "SyllablePitchDeltaConfidence": 0.19449864
                                            }
                                        }
                                    }
                                }
                            },
                            "Syllables": [
                                {
                                    "Syllable": "aen",
                                    "Grapheme": "an",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 94
                                    },
                                    "Offset": 35000000,
                                    "Duration": 2400000
                                },
                                {
                                    "Syllable": "jhax",
                                    "Grapheme": "ge",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 100
                                    },
                                    "Offset": 37500000,
                                    "Duration": 1100000
                                },
                                {
                                    "Syllable": "lihs",
                                    "Grapheme": "les",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 84
                                    },
                                    "Offset": 38700000,
                                    "Duration": 3500000
                                }
                            ],
                            "Phonemes": [
                                {
                                    "Phoneme": "ae",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 88
                                    },
                                    "Offset": 35000000,
                                    "Duration": 1200000
                                },
                                {
                                    "Phoneme": "n",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 100
                                    },
                                    "Offset": 36300000,
                                    "Duration": 1100000
                                },
                                {
                                    "Phoneme": "jh",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 100
                                    },
                                    "Offset": 37500000,
                                    "Duration": 500000
                                },
                                {
                                    "Phoneme": "ax",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 100
                                    },
                                    "Offset": 38100000,
                                    "Duration": 500000
                                },
                                {
                                    "Phoneme": "l",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 100
                                    },
                                    "Offset": 38700000,
                                    "Duration": 500000
                                },
                                {
                                    "Phoneme": "ih",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 100
                                    },
                                    "Offset": 39300000,
                                    "Duration": 1300000
                                },
                                {
                                    "Phoneme": "s",
                                    "PronunciationAssessment": {
                                        "AccuracyScore": 63
                                    },
                                    "Offset": 40700000,
                                    "Duration": 1500000
                                }
                            ]
                        }
                    ]
                }
            ]
        },
        "errorMessage": null
    },
    "success": true
}
```