from app.database import SessionLocal
from app.models.intervention import Intervention, InterventionCategory, InterventionDifficulty

def seed_interventions():
    db = SessionLocal()
    
    interventions = [
        Intervention(
            title="Phonics Flash Cards",
            description="Practice letter-sound relationships using colorful flash cards",
            category=InterventionCategory.READING,
            difficulty_level=InterventionDifficulty.BEGINNER,
            age_range_min=5,
            age_range_max=8,
            grade_levels="1,2",
            duration_minutes=15,
            instructions="Show each flash card, have child say the sound aloud. Practice for 10-15 minutes daily.",
            materials_needed="Flash cards, timer",
            learning_objectives="Letter recognition, phonemic awareness"
        ),
        Intervention(
            title="Sight Word Bingo",
            description="Learn common sight words through a fun bingo game",
            category=InterventionCategory.READING,
            difficulty_level=InterventionDifficulty.BEGINNER,
            age_range_min=6,
            age_range_max=9,
            grade_levels="1,2,3",
            duration_minutes=20,
            instructions="Create bingo cards with sight words. Call out words and have children mark them.",
            materials_needed="Bingo cards, markers, word list",
            learning_objectives="Sight word recognition, reading fluency"
        ),
        Intervention(
            title="Sentence Building Blocks",
            description="Construct sentences using color-coded word blocks",
            category=InterventionCategory.READING,
            difficulty_level=InterventionDifficulty.INTERMEDIATE,
            age_range_min=7,
            age_range_max=10,
            grade_levels="2,3,4",
            duration_minutes=25,
            instructions="Use colored blocks representing nouns, verbs, adjectives to build grammatically correct sentences.",
            materials_needed="Word blocks, sentence templates",
            learning_objectives="Grammar, sentence structure, vocabulary"
        ),
        Intervention(
            title="Tracing Practice Sheets",
            description="Improve handwriting through guided tracing exercises",
            category=InterventionCategory.WRITING,
            difficulty_level=InterventionDifficulty.BEGINNER,
            age_range_min=5,
            age_range_max=8,
            grade_levels="1,2",
            duration_minutes=15,
            instructions="Have child trace letters and words on practice sheets. Start with simple letters, progress to words.",
            materials_needed="Tracing sheets, pencils",
            learning_objectives="Fine motor skills, letter formation"
        ),
        Intervention(
            title="Story Starters",
            description="Creative writing prompts to encourage expression",
            category=InterventionCategory.WRITING,
            difficulty_level=InterventionDifficulty.INTERMEDIATE,
            age_range_min=8,
            age_range_max=12,
            grade_levels="3,4,5,6",
            duration_minutes=30,
            instructions="Provide a story starter sentence and have child complete the story. Encourage creativity.",
            materials_needed="Writing paper, pencils, prompt cards",
            learning_objectives="Creative writing, narrative structure, vocabulary"
        ),
        Intervention(
            title="Memory Card Game",
            description="Classic memory matching game to improve working memory",
            category=InterventionCategory.MEMORY,
            difficulty_level=InterventionDifficulty.BEGINNER,
            age_range_min=5,
            age_range_max=10,
            grade_levels="1,2,3,4",
            duration_minutes=15,
            instructions="Place cards face down, flip two at a time to find matches. Increase card count as skill improves.",
            materials_needed="Memory card deck",
            learning_objectives="Working memory, visual memory, concentration"
        ),
        Intervention(
            title="Number Sequence Recall",
            description="Remember and repeat increasingly long number sequences",
            category=InterventionCategory.MEMORY,
            difficulty_level=InterventionDifficulty.INTERMEDIATE,
            age_range_min=7,
            age_range_max=12,
            grade_levels="2,3,4,5,6",
            duration_minutes=20,
            instructions="Say a sequence of numbers, have child repeat them back. Start with 3 numbers, increase gradually.",
            materials_needed="None",
            learning_objectives="Auditory memory, working memory, attention"
        ),
        Intervention(
            title="Focus Timer Activities",
            description="Build attention span using timed focused activities",
            category=InterventionCategory.ATTENTION,
            difficulty_level=InterventionDifficulty.BEGINNER,
            age_range_min=6,
            age_range_max=10,
            grade_levels="1,2,3,4",
            duration_minutes=20,
            instructions="Set a timer for 5-10 minutes. Child must focus on one activity until timer goes off. Gradually increase time.",
            materials_needed="Timer, activity materials",
            learning_objectives="Sustained attention, focus, self-regulation"
        ),
        Intervention(
            title="Simon Says",
            description="Classic game to improve listening and attention skills",
            category=InterventionCategory.ATTENTION,
            difficulty_level=InterventionDifficulty.BEGINNER,
            age_range_min=5,
            age_range_max=9,
            grade_levels="1,2,3",
            duration_minutes=15,
            instructions="Give instructions starting with 'Simon says'. Child must only follow commands that start with this phrase.",
            materials_needed="None",
            learning_objectives="Selective attention, impulse control, listening skills"
        ),
        Intervention(
            title="Math Manipulatives",
            description="Use physical objects to understand math concepts",
            category=InterventionCategory.MATH,
            difficulty_level=InterventionDifficulty.BEGINNER,
            age_range_min=5,
            age_range_max=9,
            grade_levels="1,2,3",
            duration_minutes=25,
            instructions="Use blocks, counters, or other objects to demonstrate addition, subtraction, and basic math concepts.",
            materials_needed="Math manipulatives (blocks, counters)",
            learning_objectives="Number sense, basic operations, concrete math understanding"
        ),
        Intervention(
            title="Math Fact Flash Cards",
            description="Memorize basic math facts through repetition",
            category=InterventionCategory.MATH,
            difficulty_level=InterventionDifficulty.INTERMEDIATE,
            age_range_min=7,
            age_range_max=11,
            grade_levels="2,3,4,5",
            duration_minutes=15,
            instructions="Practice addition, subtraction, multiplication, and division facts using flash cards daily.",
            materials_needed="Math fact flash cards",
            learning_objectives="Math fact fluency, mental math"
        ),
        Intervention(
            title="Turn-Taking Games",
            description="Practice social skills through structured turn-taking activities",
            category=InterventionCategory.SOCIAL,
            difficulty_level=InterventionDifficulty.BEGINNER,
            age_range_min=5,
            age_range_max=10,
            grade_levels="1,2,3,4",
            duration_minutes=20,
            instructions="Play board games or group activities that require waiting for turns and following rules.",
            materials_needed="Board games, group activity materials",
            learning_objectives="Turn-taking, patience, social rules"
        ),
        Intervention(
            title="Emotion Charades",
            description="Recognize and express emotions through charades",
            category=InterventionCategory.SOCIAL,
            difficulty_level=InterventionDifficulty.INTERMEDIATE,
            age_range_min=7,
            age_range_max=12,
            grade_levels="2,3,4,5,6",
            duration_minutes=20,
            instructions="Act out different emotions while others guess. Discuss when we feel these emotions.",
            materials_needed="Emotion cards",
            learning_objectives="Emotion recognition, social awareness, expression"
        ),
    ]
    
    try:
        for intervention in interventions:
            db.add(intervention)
        db.commit()
        print(f"Successfully seeded {len(interventions)} interventions")
    except Exception as e:
        db.rollback()
        print(f"Error seeding interventions: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    seed_interventions()
