UPDATE QuestionResource 
SET ResourceText = REPLACE(CAST(ResourceText AS NVARCHAR(MAX)), '—', '-') 
WHERE ResourceName LIKE 'Reading Passage%';

UPDATE QuestionResource 
SET ResourceText = REPLACE(CAST(ResourceText AS NVARCHAR(MAX)), 'â€”', '-') 
WHERE ResourceName LIKE 'Reading Passage%';

UPDATE QuestionResource 
SET ResourceText = REPLACE(CAST(ResourceText AS NVARCHAR(MAX)), '?"', '-') 
WHERE ResourceName LIKE 'Reading Passage%';
