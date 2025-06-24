# Community Hub - Supabase Setup Instructions

This document contains the SQL commands and setup instructions for implementing the Community Hub feature in your Flutter app.

## Database Tables

### 1. Topics Table

Create the `topics` table to store discussion topics:

```sql
-- Create topics table
CREATE TABLE public.topics (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    image_url TEXT,
    posts_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true
);

-- Add indexes for better performance
CREATE INDEX idx_topics_created_at ON public.topics(created_at DESC);
CREATE INDEX idx_topics_is_active ON public.topics(is_active);
CREATE INDEX idx_topics_posts_count ON public.topics(posts_count DESC);
```

### 2. Community Posts Table

Create the `community_posts` table to store posts within topics:

```sql
-- Create community_posts table
CREATE TABLE public.community_posts (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    topic_id BIGINT REFERENCES public.topics(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    likes_count INTEGER DEFAULT 0,
    comments_count INTEGER DEFAULT 0,
    image_url TEXT,
    user_name TEXT,
    user_avatar TEXT
);

-- Add indexes for better performance
CREATE INDEX idx_community_posts_topic_id ON public.community_posts(topic_id);
CREATE INDEX idx_community_posts_user_id ON public.community_posts(user_id);
CREATE INDEX idx_community_posts_created_at ON public.community_posts(created_at DESC);
CREATE INDEX idx_community_posts_likes_count ON public.community_posts(likes_count DESC);
```

### 3. Post Comments Table

Create the `post_comments` table to store comments on posts:

```sql
-- Create post_comments table
CREATE TABLE public.post_comments (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    post_id BIGINT REFERENCES public.community_posts(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    user_name TEXT,
    user_avatar TEXT
);

-- Add indexes for better performance
CREATE INDEX idx_post_comments_post_id ON public.post_comments(post_id);
CREATE INDEX idx_post_comments_user_id ON public.post_comments(user_id);
CREATE INDEX idx_post_comments_created_at ON public.post_comments(created_at DESC);
```

### 4. Post Likes Table (Optional)

Create a table to track individual post likes:

```sql
-- Create post_likes table for tracking individual likes
CREATE TABLE public.post_likes (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    post_id BIGINT REFERENCES public.community_posts(id) ON DELETE CASCADE,
    UNIQUE(user_id, post_id)
);

-- Add indexes
CREATE INDEX idx_post_likes_user_id ON public.post_likes(user_id);
CREATE INDEX idx_post_likes_post_id ON public.post_likes(post_id);
```

## Row Level Security (RLS) Policies

### Topics Table Policies

```sql
-- Enable RLS on topics table
ALTER TABLE public.topics ENABLE ROW LEVEL SECURITY;

-- Allow everyone to read active topics
CREATE POLICY "Allow public read access to active topics" ON public.topics
    FOR SELECT USING (is_active = true);

-- Allow authenticated users to create topics (optional - you might want admin-only)
CREATE POLICY "Allow authenticated users to create topics" ON public.topics
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Allow topic creators or admins to update topics
CREATE POLICY "Allow topic management" ON public.topics
    FOR UPDATE USING (auth.role() = 'authenticated');
```

### Community Posts Table Policies

```sql
-- Enable RLS on community_posts table
ALTER TABLE public.community_posts ENABLE ROW LEVEL SECURITY;

-- Allow everyone to read posts
CREATE POLICY "Allow public read access to posts" ON public.community_posts
    FOR SELECT USING (true);

-- Allow authenticated users to create posts
CREATE POLICY "Allow authenticated users to create posts" ON public.community_posts
    FOR INSERT WITH CHECK (auth.role() = 'authenticated' AND auth.uid() = user_id);

-- Allow users to update their own posts
CREATE POLICY "Allow users to update own posts" ON public.community_posts
    FOR UPDATE USING (auth.uid() = user_id);

-- Allow users to delete their own posts
CREATE POLICY "Allow users to delete own posts" ON public.community_posts
    FOR DELETE USING (auth.uid() = user_id);
```

### Post Comments Table Policies

```sql
-- Enable RLS on post_comments table
ALTER TABLE public.post_comments ENABLE ROW LEVEL SECURITY;

-- Allow everyone to read comments
CREATE POLICY "Allow public read access to comments" ON public.post_comments
    FOR SELECT USING (true);

-- Allow authenticated users to create comments
CREATE POLICY "Allow authenticated users to create comments" ON public.post_comments
    FOR INSERT WITH CHECK (auth.role() = 'authenticated' AND auth.uid() = user_id);

-- Allow users to update their own comments
CREATE POLICY "Allow users to update own comments" ON public.post_comments
    FOR UPDATE USING (auth.uid() = user_id);

-- Allow users to delete their own comments
CREATE POLICY "Allow users to delete own comments" ON public.post_comments
    FOR DELETE USING (auth.uid() = user_id);
```

### Post Likes Table Policies

```sql
-- Enable RLS on post_likes table
ALTER TABLE public.post_likes ENABLE ROW LEVEL SECURITY;

-- Allow everyone to read likes
CREATE POLICY "Allow public read access to likes" ON public.post_likes
    FOR SELECT USING (true);

-- Allow authenticated users to like posts
CREATE POLICY "Allow authenticated users to like posts" ON public.post_likes
    FOR INSERT WITH CHECK (auth.role() = 'authenticated' AND auth.uid() = user_id);

-- Allow users to unlike posts
CREATE POLICY "Allow users to unlike posts" ON public.post_likes
    FOR DELETE USING (auth.uid() = user_id);
```

## Database Functions

### Function to Update Posts Count

```sql
-- Function to update posts count in topics table
CREATE OR REPLACE FUNCTION update_topic_posts_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.topics 
        SET posts_count = posts_count + 1 
        WHERE id = NEW.topic_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.topics 
        SET posts_count = posts_count - 1 
        WHERE id = OLD.topic_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for posts count
CREATE TRIGGER trigger_update_topic_posts_count
    AFTER INSERT OR DELETE ON public.community_posts
    FOR EACH ROW EXECUTE FUNCTION update_topic_posts_count();
```

### Function to Update Likes Count

```sql
-- Function to update likes count in community_posts table
CREATE OR REPLACE FUNCTION update_post_likes_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.community_posts 
        SET likes_count = likes_count + 1 
        WHERE id = NEW.post_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.community_posts 
        SET likes_count = likes_count - 1 
        WHERE id = OLD.post_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for likes count
CREATE TRIGGER trigger_update_post_likes_count
    AFTER INSERT OR DELETE ON public.post_likes
    FOR EACH ROW EXECUTE FUNCTION update_post_likes_count();
```

## Sample Data

### Insert Sample News Topics

```sql
-- Insert sample news topics (manually updated)
INSERT INTO public.topics (title, description, image_url, is_active) VALUES
('African Union Summit 2024: New Trade Agreements Signed', 'Leaders from 55 African nations gather in Addis Ababa to discuss continental trade partnerships and economic integration initiatives.', NULL, true),
('Nigeria''s Tech Sector Receives $2.3B Investment Boost', 'Major international investors commit significant funding to Nigerian fintech and e-commerce startups, signaling confidence in West African markets.', NULL, true),
('Kenya Launches Africa''s Largest Solar Power Plant', 'The 310MW solar facility in Garissa County will provide clean energy to over 350,000 homes, marking a milestone in renewable energy adoption.', NULL, true),
('South African Mining Strike Enters Third Week', 'Platinum and gold miners continue protests over wage disputes, affecting global commodity prices and local economic stability.', NULL, true),
('Ghana''s Cocoa Farmers Adopt Digital Payment Systems', 'New mobile money integration helps farmers receive payments faster and more securely, revolutionizing agricultural commerce.', NULL, true),
('Morocco Hosts COP29 Preparatory Climate Summit', 'Environmental ministers from across Africa meet in Rabat to coordinate climate action strategies ahead of the global climate conference.', NULL, true),
('Ethiopian Airlines Expands Routes to 15 New African Cities', 'The continent''s largest carrier announces major expansion plan, improving connectivity and boosting intra-African trade and tourism.', NULL, true),
('Senegal''s New High-Speed Rail Project Breaks Ground', 'The $2.7 billion railway connecting Dakar to regional economic centers promises to transform transportation and commerce in West Africa.', NULL, true),
('Rwanda Becomes First African Country to Launch CBDC', 'The digital Rwandan franc pilot program aims to enhance financial inclusion and reduce transaction costs for citizens and businesses.', NULL, true),
('Tanzania Discovers Major Natural Gas Reserves', 'New offshore discoveries could position Tanzania as a key energy exporter, with potential to transform the nation''s economic landscape.', NULL, true);
```

### Insert Sample Posts for Testing

```sql
-- Insert sample posts for the news topics (for testing purposes)
-- Note: Replace user_id with actual user IDs from your auth.users table
-- IMPORTANT: Make sure to run the topics INSERT statements FIRST before inserting posts!
-- The posts reference topic_id which must exist in the topics table.

-- NOTE: Replace user_id with actual authenticated user UUIDs from your Supabase auth.users table
-- For testing purposes, you can use NULL for user_id, but in production, these should be real user IDs

INSERT INTO public.community_posts (user_id, topic_id, content, user_name, user_avatar) VALUES
-- Posts for African Union Summit topic (topic_id: 1)
(NULL, 1, 'This is a historic moment for African trade! The new agreements could boost intra-African commerce by 40%. What are your thoughts on the implementation timeline?', 'John Mensah', 'https://example.com/avatar1.jpg'),
(NULL, 1, 'I attended the summit as a trade representative. The energy in the room was incredible. African leaders are truly committed to economic integration this time.', 'Amina Hassan', 'https://example.com/avatar2.jpg'),
(NULL, 1, 'Great news! But we need to ensure small businesses can also benefit from these trade agreements, not just large corporations.', 'David Okafor', 'https://example.com/avatar3.jpg'),

-- Posts for Nigeria Tech Investment topic (topic_id: 2)
(NULL, 2, 'As a Nigerian fintech founder, this investment wave is game-changing! Finally, international investors are recognizing our potential.', 'John Mensah', 'https://example.com/avatar1.jpg'),
(NULL, 2, 'The $2.3B investment shows confidence in African innovation. I hope other West African countries can attract similar investments.', 'Fatima Diallo', 'https://example.com/avatar4.jpg'),
(NULL, 2, 'This could create thousands of tech jobs across Nigeria. Exciting times for young African developers and entrepreneurs!', 'Amina Hassan', 'https://example.com/avatar2.jpg'),

-- Posts for Kenya Solar Plant topic (topic_id: 3)
(NULL, 3, 'Kenya continues to lead in renewable energy adoption! This solar plant will be a model for other African nations.', 'Peter Kimani', 'https://example.com/avatar5.jpg'),
(NULL, 3, 'Clean energy for 350,000 homes is massive! Climate change action and economic development can go hand in hand.', 'David Okafor', 'https://example.com/avatar3.jpg'),
(NULL, 3, 'I work in the renewable energy sector. Projects like this prove that Africa can leapfrog to clean technology solutions.', 'Sarah Mwangi', 'https://example.com/avatar6.jpg');

-- Update posts count for topics (this will be handled automatically by triggers, but for initial setup)
UPDATE public.topics SET posts_count = 3 WHERE id IN (1, 2, 3);

-- Alternative: If you want to use real user IDs, first create some test users or get existing user IDs:
-- SELECT id FROM auth.users LIMIT 5;
-- Then replace the NULL values above with actual user UUIDs from your auth.users table
```

### Insert Sample Comments for Testing

```sql
-- Insert sample comments for the posts (for testing purposes)
-- Note: Replace user_id with actual user IDs from your auth.users table
-- IMPORTANT: Make sure to run the posts INSERT statements FIRST before inserting comments!
-- The comments reference post_id which must exist in the community_posts table.

-- NOTE: Replace user_id with actual authenticated user UUIDs from your Supabase auth.users table
-- For testing purposes, you can use NULL for user_id, but in production, these should be real user IDs

INSERT INTO public.post_comments (user_id, post_id, content, user_name, user_avatar) VALUES
-- Comments for first post (post_id: 29)
(NULL, 29, 'Absolutely agree! The timeline is crucial for success. Hope they can implement within 2 years.', 'Sarah Mwangi', NULL),
(NULL, 29, 'I''m optimistic about this. African unity in trade has been a long time coming!', 'Peter Kimani', NULL),
(NULL, 29, 'The devil is in the details. Let''s see how they handle customs and border procedures.', 'Fatima Diallo', NULL),

-- Comments for second post (post_id: 30)
(NULL, 30, 'That''s amazing! Were there any specific sectors that got the most attention?', 'David Okafor', NULL),
(NULL, 30, 'The commitment from leaders was evident. Now we need to see action on the ground.', 'John Mensah', NULL),

-- Comments for third post (post_id: 31)
(NULL, 31, 'Small businesses are the backbone of African economies. This is so important!', 'Amina Hassan', NULL),
(NULL, 31, 'Exactly! We need inclusive growth, not just benefits for big corporations.', 'Sarah Mwangi', NULL),

-- Comments for fourth post (post_id: 32)
(NULL, 32, 'Which fintech areas are getting the most investment? Payments, lending, or crypto?', 'Peter Kimani', NULL),
(NULL, 32, 'Congratulations! This will inspire more entrepreneurs across the continent.', 'Fatima Diallo', NULL),

-- Comments for fifth post (post_id: 33)
(NULL, 33, 'Ghana and Senegal are also making great strides in attracting tech investment!', 'David Okafor', NULL),

-- Comments for sixth post (post_id: 34)
(NULL, 34, 'The job creation potential is huge! Africa''s tech talent is finally getting recognized.', 'Sarah Mwangi', NULL),

-- Comments for seventh post (post_id: 35)
(NULL, 35, 'Kenya has always been a renewable energy pioneer in East Africa. Well done!', 'Amina Hassan', NULL),
(NULL, 35, 'This will inspire other countries to invest more in solar and wind energy.', 'John Mensah', NULL),

-- Comments for eighth post (post_id: 36)
(NULL, 36, 'Climate action and development can definitely work together. Great example!', 'Peter Kimani', NULL),

-- Comments for ninth post (post_id: 37)
(NULL, 37, 'What other renewable energy projects are you working on? This is inspiring!', 'Fatima Diallo', NULL),
(NULL, 37, 'Africa has so much solar potential. We should be leading the world in this!', 'David Okafor', NULL);

-- Update comments count for posts (this will be handled automatically by triggers, but for initial setup)
UPDATE public.community_posts SET comments_count = 3 WHERE id = 29;
UPDATE public.community_posts SET comments_count = 2 WHERE id IN (30, 31, 32, 35, 36);
UPDATE public.community_posts SET comments_count = 1 WHERE id IN (33, 34, 37);

-- Alternative: If you want to use real user IDs, first create some test users or get existing user IDs:
-- SELECT id FROM auth.users LIMIT 5;
-- Then replace the NULL values above with actual user UUIDs from your auth.users table
```

## Setup Instructions

1. **Access Supabase Dashboard**
   - Go to your Supabase project dashboard
   - Navigate to the SQL Editor

2. **Execute SQL Commands**
   - Copy and paste each SQL block above in order
   - Execute them one by one in the SQL Editor
   - Ensure each command executes successfully before proceeding

3. **Verify Tables**
   - Go to the Table Editor in Supabase
   - Confirm that `topics`, `community_posts`, and `post_likes` tables are created
   - Check that the indexes and triggers are in place

4. **Test RLS Policies**
   - Try inserting sample data
   - Test with different user authentication states
   - Ensure policies work as expected

5. **Update Flutter App**
   - The Dart table definitions in your Flutter app should match these SQL schemas
   - Test the Community Hub feature in your app
   - Verify data fetching and posting works correctly

## Notes

- **Image URLs**: Replace placeholder image URLs with actual images or remove the image_url fields if not needed
- **User Management**: The `user_name` and `user_avatar` fields in `community_posts` can be populated from your user profiles table
- **Moderation**: Consider adding moderation features like reporting and admin controls
- **Performance**: Monitor query performance and add additional indexes as needed
- **Backup**: Always backup your database before making schema changes

## Troubleshooting

- If RLS policies are too restrictive, temporarily disable them for testing
- Check Supabase logs for any constraint violations or permission errors
- Ensure your Flutter app's Supabase client has the correct permissions
- Verify that user authentication is working properly in your app