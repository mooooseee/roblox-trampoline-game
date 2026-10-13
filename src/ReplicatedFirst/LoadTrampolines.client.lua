local CollectionService = game:GetService("CollectionService");
local ContentProvider = game:GetService("ContentProvider");
--/load tramps
ContentProvider:PreloadAsync(CollectionService:GetTagged("trampoline"));
ContentProvider:PreloadAsync(CollectionService:GetTagged("hitbox"));
ContentProvider:PreloadAsync(CollectionService:GetTagged("angledTramp"))
--\

